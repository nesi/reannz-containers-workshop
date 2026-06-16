# 6. Running Containers with MPI

!!! clipboard-list "Lesson Objectives"

    - Run images using `run`, `exec` and `shell` in Apptainer

!!! clipboard-question "Questions"

    - How do I run an container in apptainer?
    - How do I perform any command using the container?

Running jobs in parallel is crucial to gain the benefits of using an HPC. HPCs deal with parallalisation in multiple ways, but one way is to harness the Message Passing Interface (MPI) protocol.

It is possible to run MPI with containers, however it can be a bit tricky. This is because MPI allows programs the ability to use multiple nodes to run a program, allowing a process run from the container to effectively escape the container. You can find more detail about this on [this blog site](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/).

In this lesson, we will look at two methods for using MPI with containers. This lesson follows [this blog post by Dave Godlove](https://ciq.com/blog/a-new-approach-to-mpi-in-apptainer/), with admendments added for using Mahuika. 

## The two methods of using MPI with Containers

There are two main methods for using MPI with Containers. These are:

* The hybrid model
* The binding model

Both these methods have their advantages and disadvantages, and there is no one right way to use MPI with containers. Often, you will need to perform some trial and error on your specific container to see which will work for you. 

### The Hybrid Model

In the hybrid model, we install the same version of MPI on the container as we have on our computer/HPC. In most cases you will have been provided a container and it may have OpenMPI install on it. In this case, we will use a container that was built using [this definition file](https://www.youtube.com/watch?v=dQw4w9WgXcQ). This container was built using OpenMPI `5.0.10`. We can see this by typing into the terminal:

```bash
apptainer exec mpi_hybrid_container.sif /opt/ompi/bin/mpiexec --version
```

You should get:

```bash
user.name@computer-name:$ apptainer exec mpi_hybrid_container.sif /opt/ompi/bin/mpiexec --version
mpiexec (Open MPI) 5.0.10

Report bugs to https://www.open-mpi.org/community/help/
```

We can now try running a slurm script to run this container. Notice that we have loaded OpenMPI `5.0.10` in this script. This will allow external nodes to use OpenMPI `5.0.10` from _outside_ the container, while the host node will use the containers OpenMPI `5.0.10` from _inside_ the container:

```sh
#!/bin/bash -e
#SBATCH --job-name=apptainer-hybrid-mpi
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --time=00:05:00

module load OpenMPI/5.0.10-GCC-15.2.0
 
mpirun -n 4 apptainer exec mpi_hybrid_container.sif /opt/mpi_hello_world
```

Once you have submitted this to slurm (`sbatch submit.sl`) and the job has run, you should obtain an output file that shows something similar to this:

```bash
user.name@computer-name:$ bash submit.sl 
Hello world! Processor login03.hpc.nesi.org.nz, Rank 2 of 4, CPU 33, NUMA node 2, Namespace mnt:[4026537071]
Hello world! Processor login03.hpc.nesi.org.nz, Rank 3 of 4, CPU 183, NUMA node 3, Namespace mnt:[4026537069]
Hello world! Processor login03.hpc.nesi.org.nz, Rank 1 of 4, CPU 20, NUMA node 1, Namespace mnt:[4026537070]
Hello world! Processor login03.hpc.nesi.org.nz, Rank 0 of 4, CPU 141, NUMA node 0, Namespace mnt:[4026537072]
```

!!! note
    If you see any working regarding UCX, you can ignore these.

## Exercises

OK, lets consider we have been given a 


!!! graduation-cap "Keypoints"

- Use `apptainer --help` to list all the options available in Apptainer
