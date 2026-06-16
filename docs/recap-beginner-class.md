# Recap Beginner Lesson

Welcome back! Before we move on to the more advanced topics, let's quickly remind ourselves of what we covered in the beginner class. Don't worry if you didn't attend the beginner class — this page gives you everything you need to follow along today.

## What is a container?

A container packages a piece of software together with **all of its dependencies** into a single, portable file. That file runs the same way on your own computer and on an HPC like Mahuika, which makes your work reproducible and easy to share. In Apptainer, a built container is a single `sif` file (Singularity Image Format).

## The commands you should know

These are the commands we will lean on today:

| Command | What it does |
|---------|--------------|
| `run` | Runs the container as its creator intended (the `%runscript`). |
| `exec` | Runs a custom command of your choice inside the container. |
| `shell` | Opens an interactive session inside the container. |
| `pull` | Downloads a container from the cloud as a `sif` file. |
| `build` | Builds a `sif` container from a `def` file. |

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
* `%runscript` — what happens when someone runs the container with `apptainer run`.

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

## What's coming up today

Now that we are back up to speed, the advanced class builds on these foundations to:

* **inspect, "edit", and version** containers,
* **test** containers so you can be confident they work,
* **secure and encrypt** containers, and
* run containers in parallel across an HPC using **MPI**.

!!! clipboard-question "Quick check"

    Before we start, make sure you can answer these:

    - What is the difference between `run`, `exec`, and `shell`?
    - What does the `%post` section of a `def` file do?
    - How would you build a `sif` container from a `def` file?

    If any of these are fuzzy, the beginner chapters are a good place to refresh.
