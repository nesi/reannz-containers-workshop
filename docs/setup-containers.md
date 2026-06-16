# Setup Containers

This page shows how to build the `sif` container for every `def` file used in the workshop. Building these ahead of time means the containers are ready to use when you reach each chapter.

The sections below are grouped by the chapter the containers belong to. The commands assume you are in the matching example directory (shown at the start of each section).

## 2. The Basics of Running Containers on Apptainer

From the `02_basics_of_containers` directory:

```bash
apptainer build hello-world.sif hello-world.def
apptainer build lolcow.sif lolcow.def
```

## 4. Building Containers

From the `04_building_containers` directory:

```bash
apptainer build my_python3.12.sif my_python3.12.def
apptainer build tip1.sif tip1.def
apptainer build tip2.sif tip2.def
apptainer build tip3.sif tip3.def
```

## 5. Inspecting, "Editting", and Versioning Containers

From the `05_editting_containers` directory:

```bash
apptainer build lolcow.sif lolcow.def
apptainer build hellocow.sif hellocow.def
```

## 6. Making Tests in Containers

From the `06_making_tests_in_containers` directory:

```bash
apptainer build lolcow.sif lolcow.def
apptainer build my_python3.12.sif my_python3.12.def
```

## 7. Securing Containers with Encryption

From the `07_securing_containers_with_encryption` directory. These containers are encrypted, so you build them with a passphrase (enter it when prompted):

```bash
apptainer build --passphrase encrypted.sif encrypted.def
apptainer build --passphrase secret.sif secret.def
```

## 8. Running Containers with MPI

From the `08_running_containers_with_MPI` directory. These containers build OpenMPI from source, which is CPU-intensive — it is best to build them through slurm. A few of them need an extra step.

The **hybrid** container builds everything itself, so you can build it directly:

```bash
cd hybrid_model
apptainer build mpi_hybrid_container.sif mpi_hybrid_container.def
```

The **bind** container needs the `mpi_hello_world` program compiled on the host first (it has no MPI of its own), then the container is built around it:

```bash
cd bind_model
module purge && module load OpenMPI/5.0.10-GCC-15.2.0
mpicc mpi_hello_world.c -o mpi_hello_world
apptainer build mpi_bind_container.sif mpi_bind_container.def
```

The **OSU benchmark** containers (used in the exercises) each provide a `build_osu.sh` helper that performs any host-side compilation and then builds the container:

```bash
cd questions/hybrid_model
bash build_osu.sh

cd ../bind_model
bash build_osu.sh
```
