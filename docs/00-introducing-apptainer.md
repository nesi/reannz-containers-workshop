# Apptainer: Running Containers on HPCs

!!! clipboard-list "Lesson Objectives"

    - Know about Apptainer, which we will be using for this workshop

In this section, we will introduce what a container is and why you would want to use a container.

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
    * You can ship user-space dependencies (life software)
    * While still using host drivers and hardware capabilities.

## Difference between Apptainer and Docker

## Takeaway points

!!! graduation-cap "What you take away from this overview"

    - Apptainer is a program that allows you to run and build containers

