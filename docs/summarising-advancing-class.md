# Summarising Day 2: Beyond the Basics

## What we covered today

* **Testing containers** — adding a `%test` section so the creator can build self-tests into a container, and running them with `apptainer test`.
* **Securing containers with encryption** — encrypting a container so its contents are protected, either with a passphrase or with an RSA key pair.
* **Running containers with MPI** — running containers in parallel across multiple nodes on Mahuika, using either the hybrid model or the bind model.

## The commands you now know

| Command | What it does |
|---------|--------------|
| `test` | Runs the self-tests the creator built into the container (via `%test`). |

## Testing

A container that *builds* does not always *run* correctly, so it is good practice to add a **`%test`** section — self-tests that run at the end of the build and whenever a user runs `apptainer test`.

## Securing containers with encryption

Apptainer can encrypt the contents of a container in two ways:

* with a **passphrase** (using `--passphrase` or the `APPTAINER_ENCRYPTION_PASSPHRASE` environment variable), or
* with an **RSA key pair** (using `--pem-path` to point at a public key to encrypt and a private key to run).

Either way, you need the secret to *run* the container, so the contents stay protected even if the `sif` file is shared.

## Running containers with MPI

To run a container in parallel with MPI, you choose one of two models:

* **Hybrid model** — MPI is installed *inside* the container, and it must match the version of MPI on the host.
* **Bind model** — the container has *no* MPI of its own; you bind the host's MPI (and its dependencies) into the container at runtime.
