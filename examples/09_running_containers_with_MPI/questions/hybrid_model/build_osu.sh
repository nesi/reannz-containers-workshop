#!/bin/bash -e
# ---------------------------------------------------------------------------
# Build the hybrid-model OSU container.
#
# The def file builds OpenMPI 5.0.10 and the OSU benchmarks inside the container,
# so this just runs the build. Make sure osu-micro-benchmarks-7.5.2.tar.gz is in
# this directory first. Once built, submit the job with: sbatch submit.sl
#
# Clear any runtime bind settings first: APPTAINER_BIND is honoured during the
# build too, and a leftover /usr/lib64:/hostlibs bind (from the bind model's
# submit.sl) would fail because /hostlibs does not exist while building. These
# variables belong only in submit.sl, at runtime.
# ---------------------------------------------------------------------------

unset APPTAINER_BIND APPTAINERENV_LD_LIBRARY_PATH APPTAINERENV_UCX_POSIX_USE_PROC_LINK
apptainer build osu_benchmarks.sif osu_benchmarks.def
