# Summarising Beyond the Basics

## What we covered

* **Inspecting, "editing", and versioning containers** — reading a container's metadata and runscript, recovering the `def` file it was built from, changing that file, and rebuilding it as a new version.
* **Making tests in containers** — adding a `%test` section to a `def` file so the container can check itself, both at the end of a build and whenever someone runs `apptainer test`.
* **Running containers with MPI** — running containers in parallel across multiple nodes on Mahuika, using either the hybrid model or the bind model.

## The commands you now know

| Command | What it does |
|---------|--------------|
| `inspect` | Shows a container's labels, its `%runscript`, or the `def` file it was built from. |
| `test` | Runs the tests that the creator put in the container's `%test` section. |

## Inspecting, "editing", and versioning containers

You cannot edit a container once it has been built. What you can do is recover its recipe, change it, and rebuild:

```bash
apptainer inspect my_container.sif             # labels and metadata
apptainer inspect --runscript my_container.sif # what `run` will do
apptainer inspect --deffile my_container.sif > my_container.def
apptainer build my_container.sif my_container.def
```

Whenever you change a container, bump the `Version` in `%labels` (and say what changed in the `Description`), so that you and your collaborators can tell versions apart.

## Making tests in containers

A `%test` section in a `def` file holds commands that check the container was built correctly:

```def
%test
    if command -v cowsay >/dev/null 2>&1; then
        echo "cowsay was found"
    else
        echo "ERROR: cowsay was NOT found"
        exit 1
    fi
```

The tests **pass on exit code `0`** and **fail on any non-zero exit code**. They run automatically at the end of a build (skip them with `apptainer build --notest`), and you can run them at any time with:

```bash
apptainer test my_container.sif
```

## Running containers with MPI

MPI spreads a program across multiple nodes, so processes have to communicate across the container boundary — the MPI inside the container and the MPI on the host have to work together. There are two ways of arranging this:

* **Hybrid model** — MPI is installed *inside* the container, and its version should match the version of MPI on the host.
* **Bind model** — the container has *no* MPI of its own; you bind the host's MPI (and its dependencies) into the container at runtime.

Either way, you run the container from a slurm script: load the matching MPI module, then launch it with `mpirun`:

```bash
module load OpenMPI/5.0.10-GCC-15.2.0
mpirun -n $SLURM_NTASKS apptainer exec my_mpi_container.sif /path/to/program
```

For the bind model, the slurm script also binds the host's MPI libraries (taken from `LD_LIBRARY_PATH` after loading the module) into the container before that `mpirun` line.

!!! graduation-cap "Keypoints"

    You can now look inside a container to see how it was built, rebuild it as a new, properly versioned container, ship it with tests that prove it works, and run it in parallel across Mahuika with MPI.
