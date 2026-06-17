# Introduction to Containers on High Performance Clusters (HPC)


![image](./fig/Title_Containers.png#only-light){: width="500px" .center}
![image](./fig/Title_Containers_dark.png#only-dark){: width="500px" .center}


This workshop introduces **containers** and how to use them on a High Performance Cluster (HPC) such as [Mahuika](https://docs.nesi.org.nz/). Containers let you package software, along with all of its dependencies, into a single portable file that runs the same way on your own computer and on an HPC. By the end of the workshop you will be able to find, run, build, inspect, test, secure, and run parallel (MPI) containers using [Apptainer](https://apptainer.org/).

The material is split across two days: **Day 1: The Basics of Containers** (running and building containers) and **Day 2: Beyond the Basics** (inspecting, testing, securing, and running MPI containers), with optional **supplementary** material.

| **Lesson** | **Overview** |
|:-----------|:-------------|
| [Overview of Containers](00-containers-overview.md) | What a container is, and why you would use one |
| [Apptainer: Running Containers on HPCs](00-introducing-apptainer.md) | What Apptainer is, and how it differs from Docker |
| **Day 1: The Basics of Containers** | |
| [1. Introduction to Apptainer](01-introduction.md) | Check Apptainer is available and meet the core commands |
| [2. The Basics of Running Containers on Apptainer](02-running-apptainer.md) | Use `run`, `exec`, and `shell` to work with a container |
| [3. Pulling and Running Containers from the Cloud](03-pulling-and-running-images.md) | Download and run containers from registries such as Docker Hub |
| [4. Building Containers](04-building-images.md) | Write a `def` file and build it into a `sif` container |
| **Day 2: Beyond the Basics** | |
| [5. Inspecting, "Editing", and Versioning Containers](05-editing-containers.md) | Inspect a container, recover its `def` file, and re-version it |
| [6. Making Tests in Containers](06-testing-containers.md) | Add a `%test` section and run `apptainer test` |
| [7. Securing Containers with Encryption](07-securing-containers.md) | Encrypt a container with a passphrase or an RSA key pair |
| [8. Running Containers with MPI](08-running-MPI-containers.md) | Run containers in parallel with the hybrid and bind models |
| **Supplementary** | |
| [S1: Other Options for Building Containers](S1-other_options_for_building_containers.md) | The full set of `def` file sections, build arguments, and multi-stage builds |
| [S2: Other Commands in Apptainer](S2-other-commands-in-apptainer.md) | Managing the cache and providing help text |
| [S3: Running Containers as Instances](S3-running-containers-as-instances.md) | Run a container in the background as a long-running service |
| [S4: Building a Container using Sandbox Mode](S4-building-a-container-using-sandbox-mode.md) | Build a container interactively while experimenting |


!!! clipboard-list "Getting Started"


    This workshop assumes no prior experience with containers. You should, however, be comfortable working in a Unix shell (`cd`, `ls`, editing files) and have access to an HPC such as Mahuika to run the examples. Participants should bring their laptops and plan to take part actively.

- - -

!!! copyright "Attribution Notice"

    * This workshop material draws on the official [Apptainer documentation](https://apptainer.org/docs/) and, for the MPI chapter, the [CIQ blog post on MPI in Apptainer](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/).


!!! key "License"

    REANNZ "Introduction to Containers on High Performance Clusters" is licensed under the **GNU General Public License v3.0, 29 June 2007**. ([Follow this link for more information](https://www.gnu.org/licenses/gpl-3.0.en.html))
