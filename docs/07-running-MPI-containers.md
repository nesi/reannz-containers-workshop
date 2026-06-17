# 7. Running Containers with MPI

!!! clipboard-list "Lesson Objectives"

    - Understand why running MPI inside a container is trickier than running a normal container
    - Know the two methods for using MPI with containers: the hybrid model and the bind model
    - Be able to run an MPI container on Mahuika using a slurm script

!!! clipboard-question "Questions"

    - Why is running MPI with a container more complicated than running an ordinary container?
    - What are the two ways to use MPI with a container, and how do I decide which to use?

Running jobs in parallel is crucial to gain the benefits of using an HPC. HPCs deal with parallelisation in multiple ways, but one way is to harness the Message Passing Interface (MPI) protocol.

It is possible to run MPI with containers, but it can be a bit tricky. This is because MPI spreads a program across multiple nodes, which means a process launched from the container can effectively escape the container. You can find more detail about this on [this blog site](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/).

In this lesson, we will look at two methods for using MPI with containers.

## The Two Methods of using MPI with Containers

There are two main methods for using MPI with containers. These are:

* The hybrid model
* The bind model

Both these methods have their advantages and disadvantages, and there is no one right way to use MPI with containers. Often, you will need to perform some trial and error on your specific container to see which will work for you. 

### The Hybrid Model

In the hybrid model, we install the same version of MPI on the container as we have on our computer/HPC. In most cases you will have been provided a container and it may have OpenMPI installed on it. In this case, we will use a container that was built using the following definition file (found, along with the other files it needs, in the [`hybrid_model`](https://github.com/nesi/reannz-containers-workshop/tree/main/examples/07_running_containers_with_MPI/hybrid_model) folder), which installs OpenMPI 5.0.10:

```def hl_lines="15-31"
Bootstrap: docker
From: rockylinux:9

%files
    mpi_hello_world.c /opt

%post
    dnf -y update
    dnf -y install dnf-plugins-core
    dnf config-manager --set-enabled crb
    dnf -y install wget git gcc gcc-c++ make file gcc-gfortran bzip2 \
        findutils librdmacm-devel \
        ucx ucx-devel libfabric libfabric-devel

    # Install the internal MPI inside of the container
    export OMPI_DIR=/opt/ompi
    export OMPI_VERSION=5.0.10
    export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-$OMPI_VERSION.tar.bz2"
    mkdir -p /opt/build

    cd /opt/build
    wget -O openmpi-$OMPI_VERSION.tar.bz2 $OMPI_URL && tar -xjf openmpi-$OMPI_VERSION.tar.bz2
    cd /opt/build/openmpi-$OMPI_VERSION

    ./configure --prefix=$OMPI_DIR --with-ucx --without-verbs \
        --with-libfabric --with-pmix
    make -j8 install
    cd / && rm -rf /opt/build

    export PATH=$OMPI_DIR/bin:$PATH
    export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH

    cd /opt && mpicc -o mpi_hello_world mpi_hello_world.c
```

The highlighted lines are the core MPI part of the definition file — downloading, configuring, building, and installing OpenMPI 5.0.10, and adding it to the `PATH` and `LD_LIBRARY_PATH`. The surrounding lines set up the base image, install the libraries OpenMPI relies on (RDMA, UCX, and libfabric), and compile our `mpi_hello_world.c` program with `mpicc`.

??? note "What is `LD_LIBRARY_PATH`?"

    `LD_LIBRARY_PATH` is an environment variable that tells Linux where to look for shared libraries (the `.so` files that programs load at runtime). It holds a list of directories separated by colons (`:`), for example `/path/to/libs1:/path/to/libs2:/path/to/libs3`. When a program starts, the system searches these directories (in order) to find the libraries the program needs.

    When you `module load OpenMPI/5.0.10-GCC-15.2.0` on Mahuika, it adds the directories containing the OpenMPI libraries to `LD_LIBRARY_PATH`. We will make use of this later in the bind model, where it gives us a ready-made list of where the host's MPI libraries live.

We can see the version of OpenMPI installed in the container by typing into the terminal:

```bash
apptainer exec mpi_hybrid_container.sif /opt/ompi/bin/mpiexec --version
```

You should get:

```bash
user.name@computer-name:~$ apptainer exec mpi_hybrid_container.sif /opt/ompi/bin/mpiexec --version
mpiexec (Open MPI) 5.0.10

Report bugs to https://www.open-mpi.org/community/help/
```

We can now run a slurm script for this container. Notice that we load the same version of OpenMPI (5.0.10) in the script as the one installed inside the container:

```sh hl_lines="8-9"
#!/bin/bash -e
#SBATCH --job-name=apptainer-hybrid-mpi
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --time=00:05:00

module -q purge
# Load the external MPI in the slurm script
module load OpenMPI/5.0.10-GCC-15.2.0

# Required on Mahuika: prevents a "Permission denied" error from UCX's
# shared-memory transport that otherwise stops the MPI program from running.
export APPTAINERENV_UCX_POSIX_USE_PROC_LINK=n

mpirun -n $SLURM_NTASKS apptainer exec mpi_hybrid_container.sif /opt/mpi_hello_world
```

The highlighted lines in the above slurm script load the **external** OpenMPI — the version on Mahuika that runs _outside_ the container. In the hybrid model it must match the version of OpenMPI installed _inside_ the container (here, both are OpenMPI 5.0.10).

We launch the program with `mpirun -n $SLURM_NTASKS`.

??? note "What is `$SLURM_NTASKS`?"

    `$SLURM_NTASKS` is an environment variable that slurm sets automatically to the total number of tasks you requested (here `--nodes=2` × `--ntasks-per-node=2` = 4). Using it means the number of MPI processes always matches the resources you asked slurm for, so you only have to change it in one place.

Once you have submitted this to slurm (`sbatch submit.sl`) and the job has run, you should obtain an output file that shows something similar to this:

```bash
Hello world! Processor c008.hpc.nesi.org.nz, Rank 1 of 4, CPU 167, NUMA node 1, Namespace mnt:[4026536546]
Hello world! Processor c008.hpc.nesi.org.nz, Rank 0 of 4, CPU 166, NUMA node 1, Namespace mnt:[4026536545]
Hello world! Processor c010.hpc.nesi.org.nz, Rank 3 of 4, CPU 33, NUMA node 0, Namespace mnt:[4026536577]
Hello world! Processor c010.hpc.nesi.org.nz, Rank 2 of 4, CPU 200, NUMA node 0, Namespace mnt:[4026536576]
```

### The Bind Model

In this model we do not use MPI from within the container but instead we bind-mount Mahuika's version of MPI (and the libraries it depends on) into the container at runtime. In most cases you will have been provided a container that was built _without_ MPI. For our example, we will use a container that was built using the following definition file (found, along with the other files it needs, in the [`bind_model`](https://github.com/nesi/reannz-containers-workshop/tree/main/examples/07_running_containers_with_MPI/bind_model) folder):

```def
Bootstrap: docker
From: rockylinux:9

%files
    mpi_hello_world /opt/mpi_hello_world

%environment
    export PATH="/opt:$PATH"

%post
    # InfiniBand / RDMA user-space libraries (librdmacm, libibverbs).
    # These are OS-level libs, NOT MPI — MPI itself is still bound in at runtime.
    dnf install -y rdma-core
    dnf clean all
    chmod +x /opt/mpi_hello_world

%runscript
    /opt/mpi_hello_world
```

Notice that this definition file does not install any MPI of its own — it only sets up the program and the OS-level InfiniBand/RDMA libraries. You can confirm the container has no MPI by typing into the terminal:

```bash
apptainer exec mpi_bind_container.sif which mpiexec
```

You should get:

```bash
user.name@computer-name:~$ apptainer exec mpi_bind_container.sif which mpiexec
which: no mpiexec in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)
```

We can now run a slurm script for this container. Notice that we load OpenMPI 5.0.10 in the script and bind it into the container. This lets the program _inside_ the container use Mahuika's OpenMPI 5.0.10, which lives _outside_ the container:

```sh hl_lines="10-16"
#!/bin/bash -e
#SBATCH --job-name=apptainer-bind-mpi
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
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
```

The highlighted part of this script is what makes the bind model work. After loading the OpenMPI module, Mahuika lists all the directories holding its MPI libraries in the `LD_LIBRARY_PATH` environment variable.

We need to make those directories (and a couple of others) visible _inside_ the container, which the following lines do:

```sh
# Bind Mahuika's MPI libraries (and their dependencies) into the container.
SWEEP=""
for d in $(echo "$LD_LIBRARY_PATH" | tr ':' '\n'); do
    [ -d "$d" ] && SWEEP="${SWEEP:+$SWEEP,}$d"
done
export APPTAINER_BIND="${SWEEP},/opt/mellanox/hcoll/lib,/usr/lib64:/hostlibs"
export APPTAINERENV_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/hostlibs:/opt/mellanox/hcoll/lib"
```

Breaking this down:

* **The `for` loop** splits `LD_LIBRARY_PATH` on its `:` separators (using `tr ':' '\n'`) and walks through each directory. For every directory that actually exists (`[ -d "$d" ]`), it appends the path to a comma-separated list called `SWEEP`. The result is a clean list of all the host MPI library directories, ready to hand to Apptainer.
* **`APPTAINER_BIND`** tells Apptainer which host directories to bind-mount (make available) inside the container. We give it our `SWEEP` list, plus:
    * `/opt/mellanox/hcoll/lib` — the Mellanox HCOLL collective-communication library, which OpenMPI depends on but which does not live on `LD_LIBRARY_PATH`.
    * `/usr/lib64:/hostlibs` — the host's `/usr/lib64` (holding the InfiniBand/RDMA libraries such as `librdmacm` and `libibverbs`) mounted at the path `/hostlibs` inside the container. We mount it at a _different_ path so it does not overwrite the container's own `/usr/lib64`.
* **`APPTAINERENV_LD_LIBRARY_PATH`** sets the `LD_LIBRARY_PATH` _inside_ the container (any variable prefixed with `APPTAINERENV_` is passed through to the container's environment). This tells the program inside the container where to find the libraries we just bound in — the host's library directories, plus our `/hostlibs` mount and the HCOLL library.

In short: the `for` loop gathers the host's MPI library directories, `APPTAINER_BIND` makes them (and the extra InfiniBand/HCOLL libraries) visible inside the container, and `APPTAINERENV_LD_LIBRARY_PATH` tells the program inside the container where to find them.

??? note "What is `LD_LIBRARY_PATH`?"

    `LD_LIBRARY_PATH` is an environment variable that tells Linux where to look for shared libraries (the `.so` files that programs load at runtime). It holds a list of directories separated by colons (`:`), for example `/path/to/libs1:/path/to/libs2:/path/to/libs3`. When a program starts, the system searches these directories (in order) to find the libraries the program needs.

    When you `module load OpenMPI/5.0.10-GCC-15.2.0` on Mahuika, it adds the directories containing the OpenMPI libraries to `LD_LIBRARY_PATH`. This is what the bind script reads — it is effectively a ready-made list of where the host's MPI libraries live.

Once you have submitted this to slurm (`sbatch submit.sl`) and the job has run, you should obtain an output file that shows something similar to this:

```bash
Hello world! Processor c008.hpc.nesi.org.nz, Rank 1 of 4, CPU 167, NUMA node 1, Namespace mnt:[4026536546]
Hello world! Processor c008.hpc.nesi.org.nz, Rank 0 of 4, CPU 166, NUMA node 1, Namespace mnt:[4026536545]
Hello world! Processor c010.hpc.nesi.org.nz, Rank 3 of 4, CPU 33, NUMA node 0, Namespace mnt:[4026536577]
Hello world! Processor c010.hpc.nesi.org.nz, Rank 2 of 4, CPU 200, NUMA node 0, Namespace mnt:[4026536576]
```

!!! note
    The exact directories you need to bind depend on how your host's MPI was built. If the container reports a missing library, you can list everything it cannot find at once with `apptainer exec mpi_bind_container.sif ldd /opt/mpi_hello_world | grep 'not found'`, then bind in the directories that contain those libraries.

## Exercises

!!! dumbbell "Question 1"

    What is the key difference between the **hybrid model** and the **bind model** for using MPI with containers?

    ??? success "Solution"

        In the **hybrid model**, MPI is installed *inside* the container (and should match the version of MPI on the host). In the **bind model**, the container has no MPI of its own — instead the host's MPI (and the libraries it depends on) is bind-mounted into the container at runtime.

!!! dumbbell "Question 2"

    You have a **hybrid** `osu_benchmarks.sif` container (in the [`questions/hybrid_model`](https://github.com/nesi/reannz-containers-workshop/tree/main/examples/07_running_containers_with_MPI/questions/hybrid_model) folder) with OpenMPI built in, where the benchmark programs live under the directory `$OSU_DIR`.

    Before submitting a parallel job, you want to quickly check the container works by running the `startup/osu_hello` benchmark with a single process. How could you do this interactively?

    ??? success "Solution"

        The hybrid container has OpenMPI (and therefore `mpirun`) inside it, so we can open a shell in the container (where `$OSU_DIR` is defined) and run it with a single process:

        ```bash
        apptainer shell osu_benchmarks.sif
        Apptainer> mpirun -n 1 $OSU_DIR/startup/osu_hello
        ```

        (This would not work in the bind container, which has no MPI of its own — there is no `mpirun` inside it.)

!!! dumbbell "Question 3"

    The same hybrid container has OpenMPI inside it, so we can use the **hybrid model** to run it in parallel. Write a slurm script that runs the collective benchmark `collective/osu_gather` across 4 MPI processes, with 2 processes on each of 2 nodes.

    ??? success "Solution"

        The container's `%runscript` runs whichever benchmark you name, so we launch it with `apptainer run osu_benchmarks.sif collective/osu_gather`:

        ```sh
        #!/bin/bash -e
        #SBATCH --job-name=osu-gather-hybrid
        #SBATCH --nodes=2
        #SBATCH --ntasks-per-node=2
        #SBATCH --time=00:05:00

        module -q purge
        module load OpenMPI/5.0.10-GCC-15.2.0

        # Required on Mahuika: prevents a "Permission denied" error from UCX's
        # shared-memory transport that otherwise stops the MPI program from running.
        export APPTAINERENV_UCX_POSIX_USE_PROC_LINK=n

        mpirun -n $SLURM_NTASKS apptainer run osu_benchmarks.sif collective/osu_gather
        ```

        With `--nodes=2` and `--ntasks-per-node=2`, `$SLURM_NTASKS` is 4. The host's `mpirun` launches the four containerised processes, and the matching OpenMPI inside the container performs the MPI communication between them.

!!! dumbbell "Question 4"

    There is also a **bind** version of the container (in the [`questions/bind_model`](https://github.com/nesi/reannz-containers-workshop/tree/main/examples/07_running_containers_with_MPI/questions/bind_model) folder) that has no MPI of its own. Run the *same* benchmark (`collective/osu_gather` across 4 MPI processes, with 2 processes on each of 2 nodes), but using the **bind model**. Write the slurm script.

    ??? success "Solution"

        In the bind model we do not rely on the OpenMPI inside the container — instead we bind Mahuika's OpenMPI (and its dependencies) in at runtime, exactly as we did for the bind example earlier:

        ```sh
        #!/bin/bash -e
        #SBATCH --job-name=osu-gather-bind
        #SBATCH --nodes=2
        #SBATCH --ntasks-per-node=2
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

        mpirun -n $SLURM_NTASKS apptainer run osu_benchmarks.sif collective/osu_gather
        ```

        The only difference from Question 3 is the block that binds Mahuika's OpenMPI into the container; the `mpirun` line itself is unchanged.

!!! graduation-cap "Keypoints"

    - Running MPI with a container is trickier than a normal container because MPI spreads a program across multiple nodes, so processes have to communicate across the container boundary — this means the MPI inside the container and the MPI on the host have to work together.
    - There are two ways to run MPI with containers: the **hybrid model** (MPI installed in the container) and the **bind model** (the host's MPI bound in at runtime).
    - In the **hybrid model**, the container's MPI version should match the host's MPI version.
    - In the **bind model**, the container has no MPI; you bind the host's MPI and its dependencies in.
    - You run an MPI container on Mahuika from a slurm script: load the matching MPI module, then launch with `mpirun ... apptainer exec/run ...`.

## References

- [A new approach to MPI in Apptainer — Dave Godlove (CIQ)](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/). This lesson follows this blog post, with amendments for using Mahuika.
