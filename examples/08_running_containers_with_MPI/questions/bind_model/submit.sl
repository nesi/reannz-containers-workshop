#!/bin/bash -e
#SBATCH --job-name=osu-gather-bind
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --time=00:05:00

# Bind model: the container has no MPI of its own, so we load Mahuika's OpenMPI
# and bind it (and its dependencies) into the container at runtime.
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

# The container's %runscript takes the benchmark path as an argument, so we
# launch it with `apptainer run <benchmark>`. $SLURM_NTASKS is set automatically
# from --nodes x --tasks-per-node (here 4).
mpirun -n $SLURM_NTASKS apptainer run osu_benchmarks.sif collective/osu_gather
