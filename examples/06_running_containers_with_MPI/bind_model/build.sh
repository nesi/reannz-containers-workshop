#!/bin/bash -e
# ---------------------------------------------------------------------------
# Build the bind-model MPI container.
#
# The bind container has no MPI of its own, so the mpi_hello_world program is
# compiled here on the host against Mahuika's OpenMPI. The resulting binary is
# copied into the container by the def file's %files section; at runtime
# submit.sl binds Mahuika's OpenMPI back in.
#
# Once built, submit the job with: sbatch submit.sl
# ---------------------------------------------------------------------------

# 1. Compile the program on the host against the OpenMPI we will bind in at runtime.
module -q purge
module load OpenMPI/5.0.10-GCC-15.2.0
mpicc -o mpi_hello_world mpi_hello_world.c

# 2. Build the container. Clear any runtime bind settings first: APPTAINER_BIND is
#    honoured during the build too, and a leftover /usr/lib64:/hostlibs bind would
#    fail because /hostlibs does not exist while the container is being built.
unset APPTAINER_BIND APPTAINERENV_LD_LIBRARY_PATH APPTAINERENV_UCX_POSIX_USE_PROC_LINK
apptainer build mpi_bind_container.sif mpi_bind_container.def
