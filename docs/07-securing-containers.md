# 7. Securing Containers with Encryption

!!! clipboard-list "Lesson Objectives"

    - Understand why and when you might want to encrypt a container.
    - Know the two ways Apptainer can encrypt a container (passphrase and RSA key pair).
    - Learn how to build and run an encrypted container.

!!! clipboard-question "Questions"

    - How do I protect sensitive code or data inside a container?
    - How do I run a container that someone has encrypted?

Sometimes a container holds something you do not want others to be able to read — proprietary code, a licensed application, or sensitive data. Apptainer can build a container whose **file system is encrypted**, so its contents cannot be inspected without the correct secret.

A nice property of Apptainer's encryption is that the container stays encrypted **at rest** (on disk), **in transit** (when copied around), and **while running** — it is only ever decrypted in memory at runtime. This means the unencrypted contents are never written back to disk.

## How it works

There are two ways to supply the secret used for encryption:

| Method | Flag | Environment variable | Notes |
|---|---|---|---|
| Passphrase | `--passphrase` | `APPTAINER_ENCRYPTION_PASSPHRASE` | Simpler, but **less secure** |
| RSA key pair (PEM) | `--pem-path` | `APPTAINER_ENCRYPTION_PEM_PATH` | **Recommended** |

## Using a passphrase

A passphrase is the simplest way to encrypt a container. If you use the `--passphrase` flag *without* giving the passphrase on the command line, Apptainer will prompt you for it — this keeps the secret out of your shell history.

### Building a container with a passphrase

**Build** the encrypted container (here from the example [`encrypted.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/07_securing_containers_with_encryption/encrypted.def)), entering a passphrase when prompted:

```bash
user.name@computer-name:~$ apptainer build --passphrase encrypted.sif encrypted.def
Enter encryption passphrase: 
INFO:    Starting build...
INFO:    Running post scriptlet
INFO:    Creating encrypted SIF file...
INFO:    Build complete: encrypted.sif
```

!!! warning

    Always enter the passphrase at the interactive prompt as shown above. Supplying it directly on the command line (e.g. `--passphrase <value>`) can leave your secret visible in your shell history and process list.

### Running a container with a passphrase

**Run** the encrypted container, entering the *same* passphrase when prompted:

```bash
user.name@computer-name:~$ apptainer run --passphrase encrypted.sif
Enter encryption passphrase: 
Hello World!
```

If you enter the wrong passphrase, Apptainer cannot decrypt the container and will refuse to run it. The same applies to `exec` and `shell`.

### Supplying the passphrase with an environment variable

Instead of typing the passphrase at the prompt each time, you can supply it through the `APPTAINER_ENCRYPTION_PASSPHRASE` environment variable. This is useful in scripts, where an interactive prompt is not possible. At build time you also add the `--encrypt` flag to tell Apptainer to encrypt the container:

```bash
# Build
APPTAINER_ENCRYPTION_PASSPHRASE="my-secret" apptainer build --encrypt encrypted.sif encrypted.def

# Run
APPTAINER_ENCRYPTION_PASSPHRASE="my-secret" apptainer run encrypted.sif
```

!!! warning

    Setting `APPTAINER_ENCRYPTION_PASSPHRASE` inline as above can leave your secret visible in your shell history. Where possible, prefer entering the passphrase at the interactive prompt, or better still, use an RSA key pair.

## Using an RSA key pair (PEM)

An RSA key pair is the recommended way to encrypt a container. The **public** key is used to *encrypt* (build) the container, and the matching **private** key is needed to *decrypt* (run) it — so you can build an encrypted container for someone else using only their public key.

### Generating an RSA key pair

You can create a suitable PEM key pair with `ssh-keygen`:

```bash
# Create a 4096-bit RSA private key in PEM format
ssh-keygen -t rsa -b 4096 -m pem -N '' -f encryption_key_name

# Export the matching public key in PEM format
ssh-keygen -f ./encryption_key_name.pub -e -m pem > encryption_key_name_pub.pem

# Rename the private key for clarity
mv encryption_key_name encryption_key_name_pri.pem
```

You now have `encryption_key_name_pub.pem` (public, used to build) and `encryption_key_name_pri.pem` (private, used to run — keep this secret).

### Building an encrypted container

Build the container (here from the example [`encrypted.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/07_securing_containers_with_encryption/encrypted.def)) using the **public** key:

```bash
apptainer build --pem-path=encryption_key_name_pub.pem encrypted.sif encrypted.def
```

### Running an encrypted container

Run the container using the matching **private** key:

```bash
apptainer run --pem-path=encryption_key_name_pri.pem encrypted.sif
```

The same applies to `exec` and `shell`. If you do not provide the correct key, Apptainer will not be able to decrypt and run the container.

## Exercises

For these exercises, you have a definition file called [`secret.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/07_securing_containers_with_encryption/secret.def) that you want to build into an encrypted container called `secret.sif`.

!!! dumbbell "Question 1"

    How would you build `secret.sif` from `secret.def` so that it is encrypted with a passphrase, and then run it? Use the method that does *not* leave your passphrase in your shell history.

    ??? success "Solution"

        Use the `--passphrase` flag without giving the passphrase on the command line — Apptainer will prompt you for it. Build with:

        ```bash
        apptainer build --passphrase secret.sif secret.def
        ```

        Then run it, entering the *same* passphrase when prompted:

        ```bash
        apptainer run --passphrase secret.sif
        ```

!!! dumbbell "Question 2"

    A colleague suggests building the container inside a script with:

    ```bash
    APPTAINER_ENCRYPTION_PASSPHRASE="hunter2" apptainer build --encrypt secret.sif secret.def
    ```

    Why might this be a security concern, and what could you do instead?

    ??? success "Solution"

        Because the passphrase is written directly on the command line, it can end up in your shell history (and be visible in the process list), where other people may be able to read it.

        If you can, enter the passphrase at the interactive prompt instead (`--passphrase` with no value). Better still, use an RSA key pair, which avoids having a shared secret on the command line at all.

!!! dumbbell "Question 3"

    You would rather use an RSA key pair. Write the commands to generate the key pair, build `secret.sif` from `secret.def`, and run it. Which key is used to build, and which is used to run?

    ??? success "Solution"

        **(a)** Generate the key pair:

        ```bash
        ssh-keygen -t rsa -b 4096 -m pem -N '' -f encryption_key_name
        ssh-keygen -f ./encryption_key_name.pub -e -m pem > encryption_key_name_pub.pem
        mv encryption_key_name encryption_key_name_pri.pem
        ```

        **(b)** Build the container using the **public** key:

        ```bash
        apptainer build --pem-path=encryption_key_name_pub.pem secret.sif secret.def
        ```

        **(c)** Run the container using the matching **private** key:

        ```bash
        apptainer run --pem-path=encryption_key_name_pri.pem secret.sif
        ```

        You build with the **public** key and run with the **private** key.

!!! dumbbell "Question 4"

    You want to send an encrypted container to a collaborator so that *only they* can run it, without sharing any password between you. How can the RSA method achieve this?

    ??? success "Solution"

        Ask your collaborator for their **public** key, and build the container using it (`--pem-path=their_public_key.pem`). Only someone holding the matching **private** key — your collaborator — can decrypt and run the container. Because you only ever exchange the *public* key, no secret needs to be shared between you.


!!! graduation-cap "Keypoints"

    - Apptainer can encrypt a container's file system; it stays encrypted at rest, in transit, and while running.
    - You can encrypt with a **passphrase** (`--passphrase` / `APPTAINER_ENCRYPTION_PASSPHRASE`) or, preferably, an **RSA key pair** (`--pem-path` / `APPTAINER_ENCRYPTION_PEM_PATH`).
    - You must supply the same secret to **build** and to **run** an encrypted container.

## References

- [Official Apptainer encryption documentation](https://apptainer.org/user-docs/master/encryption.html)
