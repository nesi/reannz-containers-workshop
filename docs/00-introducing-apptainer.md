# Apptainer: Running Containers on HPCs

!!! clipboard-list "Lesson Objectives"

    - Know about Apptainer, which we will be using for this workshop
    - Understand how Apptainer differs from Docker, and why it suits HPC systems

In this section, we will introduce Apptainer, the container platform we will be using throughout this workshop, and see how it differs from Docker.

## What is Apptainer?

Apptainer (formerly Singularity) is a container platform heavily used in HPC. Its design goals differ from Docker in ways that matter on shared clusters. 

The key characteristics of Apptainer are:

* Runs as the calling user:
    * You typically do not need root to run containers.
    * There’s no always-running privileged service like Docker’s daemon model.
* Integrates with HPC environments. Designed to play nicely with:
    * shared filesystems
    * SLURM job launches
    * MPI stacks (host MPI + container environment)
    * GPU passthrough (e.g., NVIDIA)
* “Bring your own environment, use the host resources”
    * You can ship your own user-space software and dependencies,
    * while still using the host's drivers and hardware capabilities.

## Difference between Apptainer and Docker

Apptainer and Docker both run containers, but Apptainer is designed for shared HPC systems like Mahuika, whereas Docker is designed for systems you have full control over. The main differences are:

* **Privileges**: Docker normally runs through a privileged background service (the Docker daemon) that runs as `root`. Apptainer has no such daemon — containers run as *you*, the calling user, so you cannot gain root access to the host. This is why HPC centres allow Apptainer but generally not Docker.
* **Image format**: Apptainer packages a container as a single `sif` file that you can copy, share, and run like any other file. Docker stores images as layers managed by the daemon.
* **HPC integration**: Apptainer is built to work with shared filesystems, the SLURM scheduler, host MPI, and GPUs out of the box.

Apptainer can also build containers *from* Docker images (using `Bootstrap: docker`), so you can still take advantage of the large ecosystem of Docker images.

!!! graduation-cap "Keypoints"

    - Apptainer is a program that allows you to run and build containers.
    - Apptainer runs containers as you (with no root daemon), packages them as single `sif` files, and integrates with HPC schedulers, MPI, and GPUs — which is why it is used on HPCs instead of Docker.

