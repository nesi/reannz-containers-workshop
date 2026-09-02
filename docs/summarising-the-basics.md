# Summarising The Basics of Containers

## What we covered

* **Introduction to Apptainer** — what Apptainer is, checking it is available on Mahuika, and the commands you will use most.
* **Running containers** — using `run`, `exec`, and `shell` to work with an existing container.
* **Pulling containers from the cloud** — downloading containers with `pull`, or running them directly from a registry such as Docker Hub.
* **Building containers** — writing a `def` file and turning it into a `sif` container with `build`.
* **Sandbox mode** — building a container interactively with `build --sandbox`, changing it with `shell --writable --contain --fakeroot`, and converting it into a `sif` container.
* **Securing containers** — encrypting a container's contents with a passphrase or an RSA key pair.

## The commands you now know

| Command | What it does |
|---------|--------------|
| `run` | Runs the container as its creator intended (the `%runscript`). |
| `exec` | Runs a custom command of your choice inside the container. |
| `shell` | Opens an interactive session inside the container. |
| `pull` | Downloads a container from the cloud as a `sif` file. |
| `build` | Builds a `sif` container from a `def` file, or a sandbox with `--sandbox`. |

## Building containers with a `def` file

A `def` file is a recipe for a container. The sections you learnt are:

* `Bootstrap` and `From` — the base image your container is built on (required).
* `%labels` — metadata such as the author and version.
* `%environment` — environment variables that are set when the container runs.
* `%post` — the commands that install and configure everything inside the container.
* `%runscript` — what happens when someone runs the container with `apptainer run` (you can pass arguments in using `$1`, `$2`, … and `$@`).

Once written, you build it with:

```bash
apptainer build my_container.sif my_container.def
```

## Building a container in sandbox mode

If you are still working out what belongs in your container, you can build it interactively instead:

```bash
apptainer build --sandbox my_container.sandbox docker://ubuntu:24.04
apptainer shell --writable --contain --fakeroot my_container.sandbox
apptainer build my_container.sif my_container.sandbox
```

Once you know what you want, write it up as a `def` file — that version is reproducible and can be inspected later.

## Securing a container with encryption

Apptainer can encrypt the contents of a container in two ways:

* with a **passphrase** (using `--passphrase` or the `APPTAINER_ENCRYPTION_PASSPHRASE` environment variable), or
* with an **RSA key pair** (using `--pem-path` or `APPTAINER_ENCRYPTION_PEM_PATH` to point at a public key to encrypt, and the private key to run) — the preferred option.

Either way you need the secret to *run* the container, so its contents stay protected even if the `sif` file is shared.

## Where to from here?

**Beyond the Basics** builds on these foundations to:

* inspect a container, recover its `def` file, and re-version it,
* add tests to a container so you can check it was built correctly,
* and run containers in parallel across an HPC using MPI.

!!! graduation-cap "Keypoints"

    Containers let you package software and all its dependencies into a single, portable file that runs the same way on your computer and on Mahuika. With `pull`, `build`, and `run`/`exec`/`shell`, you can now find, create, and use containers for your own work — building them either from a `def` file or interactively in a sandbox, and encrypting them when their contents need protecting.
