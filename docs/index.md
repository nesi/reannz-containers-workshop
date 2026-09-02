# Introduction to Containers on High Performance Clusters (HPC)


![image](./fig/Title_Containers.png#only-light){: width="500px" .center}
![image](./fig/Title_Containers_dark.png#only-dark){: width="500px" .center}


This workshop introduces **containers** and how to use them on a High Performance Cluster (HPC) such as [Mahuika](https://docs.nesi.org.nz/). Containers let you package software, along with all of its dependencies, into a single portable file that runs the same way on your own computer and on an HPC. By the end of the workshop you will be able to find, run, build, secure, inspect, test, and run parallel (MPI) containers using [Apptainer](https://apptainer.org/).

The material is split into **The Basics of Containers** (running, building, and securing containers) and **Beyond the Basics** (inspecting, testing, and running containers with MPI), with optional **supplementary** material.

!!! clipboard-list "Learning Objectives"

    By the end of this workshop, you will be able to:

    - Run software inside a container using the `run`, `exec`, and `shell` commands.
    - Find, pull, and run existing containers from registries such as Docker Hub.
    - Write a definition (`def`) file and build it into a portable `sif` container.
    - Build a container interactively using sandbox mode, then convert it into a `sif` container.
    - Secure a container by encrypting its contents with a passphrase or an RSA key pair.
    - Inspect a container, recover its `def` file, and add tests that check it was built correctly.
    - Run containers in parallel across multiple HPC nodes using MPI (the hybrid and bind models).

| **Lesson** | **Overview** |
|:-----------|:-------------|
| [Overview of Containers](00-containers-overview.md) | What a container is, and why you would use one |
| [Apptainer: Running Containers on HPCs](00-introducing-apptainer.md) | What Apptainer is, and how it differs from Docker |
| **The Basics of Containers** | |
| [1. Introduction to Apptainer](01-introduction.md) | Check Apptainer is available and meet the core commands |
| [2. The Basics of Running Containers on Apptainer](02-running-apptainer.md) | Use `run`, `exec`, and `shell` to work with a container |
| [3. Pulling and Running Containers from the Cloud](03-pulling-and-running-images.md) | Download and run containers from registries such as Docker Hub |
| [4. Building Containers](04-building-images.md) | Write a `def` file and build it into a `sif` container |
| [5. Building a Container using Sandbox Mode](05-building-a-container-using-sandbox-mode.md) | Build a container interactively while experimenting |
| [6. Securing Containers with Encryption](06-securing-containers.md) | Encrypt a container with a passphrase or an RSA key pair |
| **Beyond the Basics** | |
| [7. Inspecting, "Editing", and Versioning Containers](07-editing-containers.md) | Inspect a container, recover its `def` file, and re-version it |
| [8. Making Tests in Containers](08-testing-containers.md) | Add a `%test` section and run `apptainer test` |
| [9. Running Containers with MPI](09-running-MPI-containers.md) | Run containers in parallel with the hybrid and bind models |
| **Supplementary** | |
| [S1: Other Options for Building Containers](S1-other_options_for_building_containers.md) | The full set of `def` file sections, build arguments, and multi-stage builds |
| [S2: Other Commands in Apptainer](S2-other-commands-in-apptainer.md) | Managing the cache and providing help text |
| [S3: Running Containers as Instances](S3-running-containers-as-instances.md) | Run a container in the background as a long-running service |


!!! clipboard-list "Getting Started"


    This workshop assumes no prior experience with containers. You should, however, be comfortable working in a Unix shell (`cd`, `ls`, editing files) and have access to an HPC such as Mahuika to run the examples. Participants should bring their laptops and plan to take part actively.

- - -

!!! copyright "Attribution Notice"

    * This workshop material draws on the official [Apptainer documentation](https://apptainer.org/docs/) and, for the MPI chapter, the [CIQ blog post on MPI in Apptainer](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/).
