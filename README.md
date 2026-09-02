# Introduction to Containers on High Performance Clusters (HPC)

Workshop material for **REANNZ's "Introduction to Containers on High Performance Clusters"**. It teaches how to use [Apptainer](https://apptainer.org/) to find, run, build, inspect, test, secure, and run parallel (MPI) containers on an HPC such as [Mahuika](https://docs.nesi.org.nz/).

📖 **Read the workshop here: <https://nesi.github.io/reannz-containers-workshop/>**

The material is split into The Basics of Containers and Beyond the Basics, and the pages live in [`docs/`](docs/).

## Workshop structure

### The Basics of Containers

Running, building, and securing containers.

- Overview of Containers
- Apptainer: Running Containers on HPCs
- Chapter 1: Introduction to Apptainer
- Chapter 2: The Basics of Running Containers on Apptainer
- Chapter 3: Pulling and Running Containers from the Cloud
- Chapter 4: Building Containers
- Chapter 5: Building a Container using Sandbox Mode
- Chapter 6: Securing Containers with Encryption
- Summarising The Basics of Containers

### Beyond the Basics

Inspecting, testing, and running containers in parallel with MPI.

- Recap of The Basics of Containers
- Chapter 7: Inspecting, "Editing", and Versioning Containers
- Chapter 8: Making Tests in Containers
- Chapter 9: Running Containers with MPI
- Summarising Beyond the Basics

### Supplementary

Optional extra material:

- S1: Other Options for Building Containers
- S2: Other Commands in Apptainer
- S3: Running Containers as Instances

## Repository layout

| Path | Contents |
|------|----------|
| [`docs/`](docs/) | The lesson pages (Markdown), images, and stylesheets |
| [`examples/`](examples/) | The `def` files, slurm scripts, and build helpers used in the lessons, grouped by chapter |
| [`mkdocs.yml`](mkdocs.yml) | The MkDocs site configuration and navigation |
| [`overrides/`](overrides/) | Theme overrides |

## Building the example containers

Each chapter's containers are built from the `def` files in [`examples/`](examples/). The **Setup Containers** page in the documentation lists the exact build command for every container, including the MPI/OSU containers, which build OpenMPI from source and are best built through slurm.

## License

This workshop material is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

It draws on the official [Apptainer documentation](https://apptainer.org/docs/) and, for the MPI chapter, the [CIQ blog post on MPI in Apptainer](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/).
