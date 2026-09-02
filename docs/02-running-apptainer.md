# 2. The Basics of Running Containers on Apptainer

!!! clipboard-list "Lesson Objectives"

    - Run images using `run`, `exec` and `shell` in Apptainer

!!! clipboard-question "Questions"

    - How do I run a container the way its creator intended?
    - How do I run my own commands inside a container, or work in it interactively?

The three commands most widely used in Apptainer are `run`, `exec` and `shell`. Very briefly: 

* `run`: Performs a command as designed by the creator of the container.
* `exec`: Allows the user to perform a custom command within the container. 
* `shell`: Allows the user to run an interactive session within the container.

In this section, we will expand on how to use all three commands and see what they do. 

For these examples, we will use the `hello-world.sif` container, which is based on Ubuntu. This container is found in the `examples/02_basics_of_containers` folder:

```bash 
cd examples/02_basics_of_containers
```

## The `run` command

Consider that we want to run a container as intended by its creator. We would do this by using the `run` command in Apptainer:

```bash 
apptainer run hello-world.sif
```

This container has been designed to print out `Hello World!` when run:

```bash 
user.name@computer-name:~$ apptainer run hello-world.sif
Hello World!
```

We can look inside the container to see what the `run` command is meant to do for this container by using the `inspect --runscript` feature of Apptainer

```bash
user.name@computer-name:~$ apptainer inspect --runscript hello-world.sif
#!/bin/sh

    echo "Hello World!"
```

We will come back to the `inspect` feature in [Chapter 7](07-editing-containers.md#the-inspect-command). 

<a id="what-is-a-sif-file"></a>

!!! info "What is a `sif` file?"

    A `sif` file (short for **Singularity Image Format**) is a single file that contains an entire container — the software, its dependencies, and everything it needs to run. Because the whole container is packaged into this one file, you can easily copy, share, and run it on any machine that has Apptainer installed, such as Mahuika.

## The `exec` command

Next, let's consider we want to use the container, but we want to use it slightly differently to how the creator intended the container to be run. In this case, we want to use the `exec` command. 

For example, let's say that I want the container to actually print the text `Hello Mars!`. We could do this by typing the following into the terminal:

```bash
user.name@computer-name:~$ apptainer exec hello-world.sif echo Hello Mars!
Hello Mars!
```

What does everything mean:

* `apptainer`: We called the Apptainer program
* `exec`: This is the execution command for Apptainer
* `hello-world.sif`: This is the container we would like to perform a command using. 
* `echo Hello Mars!`: This is the command we would like to perform with our container. 

We could keep doing this for the other planets in the solar system

```bash
user.name@computer-name:~$ apptainer exec hello-world.sif echo Hello Venus!
Hello Venus!
```

## The `shell` command

Now let's consider that we actually want to work with the container interactively. To do this, we use the `shell` command. 

For example, let's say we want to interactively say hello to all the planets in the solar system (and bye to Pluto). 

```bash
user.name@computer-name:~$ apptainer shell hello-world.sif
Apptainer> echo Hello Mercury!
Hello Mercury!
Apptainer> echo Hello Venus!
Hello Venus!
Apptainer> echo Hello Earth!
Hello Earth!
Apptainer> echo Hello Mars!
Hello Mars!
Apptainer> echo Hello Jupiter!
Hello Jupiter!
Apptainer> echo Hello Saturn!
Hello Saturn!
Apptainer> echo Hello Neptune!
Hello Neptune!
Apptainer> echo Bye Pluto!
Bye Pluto!
Apptainer> exit
exit
```

Using the `shell` command, we can interactively work inside the container just like we were on a computer/terminal that was built on that container. 

## A note about using GPUs with containers

By default, a container cannot see the host's GPU. If you want to use an NVIDIA graphics card inside a container, add the `--nv` flag to your `run`, `exec`, or `shell` command. This makes the host's NVIDIA drivers and libraries available inside the container, for example:

```bash
apptainer run --nv my_container.sif
apptainer exec --nv my_container.sif my_gpu_program
apptainer shell --nv my_container.sif
```

## Exercises

OK, let's consider we have been given a container called `lolcow.sif` (found in `examples/02_basics_of_containers`):

!!! dumbbell "Question 1"

    How would you run the container as specified by the creator?

    ??? success "Solution"

        Use the `run` command by typing in `apptainer run lolcow.sif`

        ```bash
        user.name@computer-name:~$ apptainer run lolcow.sif 
         _________________________________________
        / He that breaks a thing to find out what \
        | it is has left the path of wisdom.      |
        |                                         |
        \ -- J.R.R. Tolkien                       /
         -----------------------------------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        ```

!!! dumbbell "Question 2"

    How would you get the cow to say "Hello Mars!"?

    Note: You will need to execute the line ``cowsay Hello Mars!`` in your command

    ??? success "Solution"

        There are two solutions to this

        1. Use the `exec` command by typing in `apptainer exec lolcow.sif cowsay Hello Mars!`

        ```bash
        user.name@computer-name:~$ apptainer exec lolcow.sif cowsay Hello Mars!
         _____________
        < Hello Mars! >
         -------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        ```

        2. Or, use the `shell` command by doing the following:

        ```bash
        user.name@computer-name:~$ apptainer shell lolcow.sif
        Apptainer> cowsay Hello Mars!
         _____________
        < Hello Mars! >
         -------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        Apptainer> exit  
        exit
        ```


!!! graduation-cap "Keypoints"

    - Understand how to use the `run` command to perform a specific command as designed by the creator of the container.
    - Know how to use `exec` to perform custom tasks in the container.
    - Can use `shell` to run an interactive session in the container.
