# 2. The Basics of Running Containers on Apptainer

!!! clipboard-list "Lesson Objectives"

    - Run images using `run`, `exec` and `shell` in Apptainer
    - Know about the `--writable-tmpfs` function

The first three command that are crucial to know if you want to interact with containers are `run`, `exec` and `shell`. In this section, we will look at how to use all three of these commands and see what they do. 

For these examples, we will use the `hello_world.sif` container, which is based on ubuntu. This container is found in the `../` folder:

```bash 
cd .. 
```

## The `run` command

Consider that we want to run a container as intended by its creator. We would do this by using the `run` command in apptainer:

```bash 
apptainer run hello-world.sif
```

This container has been designed to print out `Hello World!` when run:

```bash 
geoff.weal@login03:$ apptainer run hello-world.sif
Hello World!
```

We can look inside the container to see what the `run` command is meant to do for this container by using the `inspect --runscript` feature of Apptainer

```bash
geoff.weal@login03:$ apptainer inspect --runscript hello-world.sif
#!/bin/sh

    echo "Hello World!"
```

We will come back to the `inspect` feature later on. 

## The `exec` command

Next, lets consider we want to use the container, but we want to use it slightly differently to how the creator intended the container to be run. In this case, we want to use the `exec` command. 

For example, lets say that I want the container to actually print the text `Hello Mars!`. We could do this by typing the following into the terminal:

```bash
geoff.weal@login03:$ apptainer exec hello-world.sif echo Hello Mars!
Hello Mars!
```

What happened here

* `apptainer`: We called the Apptainer program
* `exec`: This is the execution command for apptainer
* `hello-world.sif`: This is the container we would like to perform a command using. 
* `echo Hello Mars!`: This is the command we would like to perform with our container. 

We could keep doing this for the other planets in the solar system

```bash
geoff.weal@login03:$ apptainer exec hello-world.sif echo Hello Venus!
Hello Venus!
```

## The `shell` command

Now lets consider that we actually want to work with the container interactively. To do this, we use the `shell` command. 

For example, lets say we want to interactively say hello to all the planets in the solar system (and bye to Pluto). 

```bash
geoff.weal@login03:$ apptainer shell hello-world.sif
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


## `--writable-tmpfs`: Another way to add files and packages to Containers

In some cases



## Exercises

OK, lets consider we have been given a container called `lolcow.sif` (found in `..`):

```bash 
cd ..
```

!!! dumbbell "Question 1"

    How would you run the container as specified by the creator?

    ??? success "Solution"

        Use the `run` command by typing in `apptainer run lolcow.sif`

        ```bash
            geoff.weal@login03:$ apptainer run lolcow.sif 
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

        1. Use the 'exec' command by typing in in `apptainer exec lolcow.sif cowsay Hello Mars!`

        ```bash
            geoff.weal@login03:$ apptainer exec lolcow.sif cowsay Hello Mars!
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
        geoff.weal@login03:$ apptainer shell lolcow.sif
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

## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Understand how to use the `run` command to perform a specific command as designed by the creator of the container.
    - Know how to use `exec` to perform custom tasks in the container.
    - Can use `shell` to run an interactive session in the container.











