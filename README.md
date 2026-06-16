# Introduction to Containers on High Performance Clusters (HPC)

Workshop material for **REANNZ's "Introduction to Containers on High Performance Clusters"**. It teaches how to use [Apptainer](https://apptainer.org/) to find, run, build, inspect, test, secure, and run parallel (MPI) containers on an HPC such as [Mahuika](https://docs.nesi.org.nz/).

📖 **Read the workshop here: <https://nesi.github.io/reannz-containers-workshop/>**

The material is delivered over two days and the pages live in [`docs/`](docs/).

## Workshop structure

### Day 1 — The Basics of Containers

Running and building containers.

- Overview of Containers
- Apptainer: Running Containers on HPCs
- Introduction to Apptainer
- The Basics of Running Containers on Apptainer
- Pulling and Running Containers from the Cloud
- Building Containers
- Summarising the Basics

### Day 2 — Beyond the Basics

Inspecting, testing, securing, and running MPI containers.

- Recap of Day 1
- Inspecting, "Editing", and Versioning Containers
- Making Tests in Containers
- Securing Containers with Encryption
- Running Containers with MPI
- Summarising Beyond the Basics

### Supplementary

Optional extra material:

- S1: Other Options for Building Containers
- S2: Other Commands in Apptainer
- S3: Building a Container using Sandbox Mode

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
