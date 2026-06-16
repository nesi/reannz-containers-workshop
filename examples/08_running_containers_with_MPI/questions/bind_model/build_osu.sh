#!/bin/bash -e
# ---------------------------------------------------------------------------
# Build the bind-model OSU container.
#
# In the bind model the container has no MPI of its own, so we compile the OSU
# benchmarks here on the host against Mahuika's OpenMPI. The resulting binaries
# are dynamically linked against libmpi.so, which we bind in at runtime (see
# submit.sl). This is the same idea as compiling mpi_hello_world on the host in
# the bind example earlier in the chapter.
#
# Make sure osu-micro-benchmarks-7.5.2.tar.gz is in this directory first.
# Once built, submit the job with: sbatch submit.sl
# ---------------------------------------------------------------------------

OSU_VERSION=7.5.2
INSTALL_DIR=$PWD/osu

# 1. Compile the OSU benchmarks on the host against the same OpenMPI we will
#    bind in at runtime, so they stay ABI-compatible with that version.
module -q purge
module load OpenMPI/5.0.10-GCC-15.2.0

tar zxvf osu-micro-benchmarks-${OSU_VERSION}.tar.gz
cd osu-micro-benchmarks-${OSU_VERSION}/
./configure --prefix=$INSTALL_DIR CC=mpicc CXX=mpicxx
make -j8
make install
cd ..

# 2. Build the container, which copies the compiled ./osu tree in via %files.
#    The container itself contains no MPI.
#
#    Clear any runtime bind settings first: APPTAINER_BIND is honoured during the
#    build too, and the /usr/lib64:/hostlibs bind would fail (the /hostlibs mount
#    point does not exist while the container is being built). These variables
#    belong only in submit.sl, at runtime.
unset APPTAINER_BIND APPTAINERENV_LD_LIBRARY_PATH APPTAINERENV_UCX_POSIX_USE_PROC_LINK
apptainer build osu_benchmarks.sif osu_benchmarks.def
