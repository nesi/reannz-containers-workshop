# Summarising Day 1: The Basics of Containers

## What we covered today

* **Introduction to Apptainer** — what Apptainer is, checking it is available on Mahuika, and the commands you will use most.
* **Running containers** — using `run`, `exec`, and `shell` to work with an existing container.
* **Pulling containers from the cloud** — downloading containers with `pull`, or running them directly from a registry such as Docker Hub.
* **Building containers** — writing a `def` file and turning it into a `sif` container with `build`.

## The commands you now know

| Command | What it does |
|---------|--------------|
| `run` | Runs the container as its creator intended (the `%runscript`). |
| `exec` | Runs a custom command of your choice inside the container. |
| `shell` | Opens an interactive session inside the container. |
| `pull` | Downloads a container from the cloud as a `sif` file. |
| `build` | Builds a `sif` container from a `def` file. |

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

## Where to from here?

On Day 2 (Beyond the Basics) we build on these foundations to:

* inspect, "edit", and version containers,
* test containers so you can be confident they work (`%test`),
* secure and encrypt containers,
* and run containers in parallel across an HPC using MPI.

!!! graduation-cap "Keypoints"

    Containers let you package software and all its dependencies into a single, portable file that runs the same way on your computer and on Mahuika. With `pull`, `build`, and `run`/`exec`/`shell`, you can now find, create, and use containers for your own work.
