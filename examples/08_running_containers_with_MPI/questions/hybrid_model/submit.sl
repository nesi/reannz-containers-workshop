#!/bin/bash -e
#SBATCH --job-name=osu-gather-hybrid
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --time=00:05:00

# Hybrid model: the OSU benchmarks were built against the OpenMPI that lives
# *inside* osu_benchmarks.sif, so we load a matching OpenMPI module on the host.
module -q purge
module load OpenMPI/5.0.10-GCC-15.2.0

# The container's %runscript takes the benchmark path as an argument and runs
# $OSU_DIR/<benchmark>, so we launch it with `apptainer run <benchmark>`.
# $SLURM_NTASKS is set automatically from --nodes x --tasks-per-node (here 4).
mpirun -n $SLURM_NTASKS apptainer run osu_benchmarks.sif collective/osu_gather
