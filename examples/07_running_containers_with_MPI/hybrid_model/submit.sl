#!/bin/bash -e
#SBATCH --job-name=apptainer-hybrid-mpi
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:05:00

module -q purge
module load OpenMPI/5.0.10-GCC-15.2.0

# Required on Mahuika: prevents a "Permission denied" error from UCX's
# shared-memory transport that otherwise stops the MPI program from running.
export APPTAINERENV_UCX_POSIX_USE_PROC_LINK=n

mpirun -n $SLURM_NTASKS apptainer exec mpi_hybrid_container.sif /opt/mpi_hello_world
