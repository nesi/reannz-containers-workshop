#!/bin/bash -e
#SBATCH --job-name=apptainer-bind-mpi
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --time=00:05:00

module -q purge
module load OpenMPI/5.0.10-GCC-15.2.0

# Bind Mahuika's MPI libraries (and their dependencies) into the container.
SWEEP=""
for d in $(echo "$LD_LIBRARY_PATH" | tr ':' '\n'); do
    [ -d "$d" ] && SWEEP="${SWEEP:+$SWEEP,}$d"
done
export APPTAINER_BIND="${SWEEP},/opt/mellanox/hcoll/lib,/usr/lib64:/hostlibs"
export APPTAINERENV_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/hostlibs:/opt/mellanox/hcoll/lib"

# Required on Mahuika: prevents a "Permission denied" error from UCX's
# shared-memory transport that otherwise stops the MPI program from running.
export APPTAINERENV_UCX_POSIX_USE_PROC_LINK=n

mpirun -n $SLURM_NTASKS apptainer exec mpi_bind_container.sif /opt/mpi_hello_world
