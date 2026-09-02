# Summarising Day 2: Beyond the Basics

## What we covered today

* **Securing containers with encryption** — encrypting a container so its contents are protected, either with a passphrase or with an RSA key pair.
* **Running containers with MPI** — running containers in parallel across multiple nodes on Mahuika, using either the hybrid model or the bind model.

## Securing containers with encryption

Apptainer can encrypt the contents of a container in two ways:

* with a **passphrase** (using `--passphrase` or the `APPTAINER_ENCRYPTION_PASSPHRASE` environment variable), or
* with an **RSA key pair** (using `--pem-path` to point at a public key to encrypt and a private key to run).

Either way, you need the secret to *run* the container, so the contents stay protected even if the `sif` file is shared.

## Running containers with MPI

To run a container in parallel with MPI, you choose one of two models:

* **Hybrid model** — MPI is installed *inside* the container, and it must match the version of MPI on the host.
* **Bind model** — the container has *no* MPI of its own; you bind the host's MPI (and its dependencies) into the container at runtime.
