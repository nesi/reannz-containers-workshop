# Recap of The Basics of Containers

Before we move on, let's quickly remind ourselves of what we covered in The Basics of Containers.

## What is a container?

A container packages a piece of software together with **all of its dependencies** into a single, portable file. That file runs the same way on your own computer and on an HPC like Mahuika, which makes your work reproducible and easy to share. In Apptainer, a built container is a single `sif` file (Singularity Image Format).

## The commands you should know

These are the commands we will lean on here:

| Command | What it does |
|---------|--------------|
| `run` | Runs the container as its creator intended (the `%runscript`). |
| `exec` | Runs a custom command of your choice inside the container. |
| `shell` | Opens an interactive session inside the container. |
| `pull` | Downloads a container from the cloud as a `sif` file. |
| `build` | Builds a `sif` container from a `def` file, or a sandbox with `--sandbox`. |

For example, to run a container, execute a one-off command in it, or open a shell:

```bash
apptainer run my_container.sif
apptainer exec my_container.sif echo "Hello World!"
apptainer shell my_container.sif
```

## Building a container from a `def` file

A `def` file is the recipe for a container. The key sections are:

* `Bootstrap` and `From` — the base image your container is built on (required).
* `%labels` — metadata such as the author and version.
* `%environment` — environment variables that are set when the container runs.
* `%post` — the commands that install and configure everything inside the container.
* `%runscript` — what happens when someone runs the container with `apptainer run` (arguments come in as `$1`, `$2`, … and `$@`).

A simple example:

```def
Bootstrap: docker
From: ubuntu:24.04

%runscript
    echo "Hello World!"
```

You then build it into a `sif` file with:

```bash
apptainer build my_container.sif my_container.def
```

## Sandboxes and encrypted containers

We also saw two other ways of working with containers:

* **Sandbox mode** — build a container interactively with `apptainer build --sandbox`, change it with `apptainer shell --writable --contain --fakeroot`, and turn the finished sandbox into a `sif` container with `apptainer build`.
* **Encryption** — protect the contents of a container with either a passphrase (`--passphrase`) or an RSA key pair (`--pem-path`), so it stays encrypted at rest, in transit, and while running.

## What's coming up

**Beyond the Basics** builds on these foundations to:

* **inspect, "edit", and version** containers,
* add **tests** to containers, and
* run containers in parallel across an HPC using **MPI**.

!!! clipboard-question "Quick check"

    Before we start, make sure you can answer these:

    - What is the difference between `run`, `exec`, and `shell`?
    - What does the `%post` section of a `def` file do?
    - How would you build a `sif` container from a `def` file?
    - When would you use a sandbox instead of a `def` file?

    If any of these are fuzzy, the earlier chapters are a good place to refresh.
