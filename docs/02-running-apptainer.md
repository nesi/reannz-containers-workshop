# 2. The Basics of Running Containers on Apptainer

!!! clipboard-list "Lesson Objectives"

    - Run images using `run`, `exec` and `shell` in Apptainer

!!! clipboard-question "Questions"

    - How do I run an container in apptainer?
    - How do I perform any command using the container?

## The `run` command

In this example, we will use the `hello_world.sif` container. Consider that we want to run a container as intended by the creator of the container. We would do this by using the `run` command in apptainer:

```bash 
apptainer run hello-world.sif
```

This container has been designed to print out `Hello World!` when run:

```bash 
apptainer run hello-world.sif
Hello World!
```

We can look inside the container to see what the `run` command is meant to do for this container by using the `inspect --runscript` feature of Apptainer

```bash
apptainer inspect --runscript hello-world.sif
#!/bin/sh

    echo "Hello World!"
```

We will come back to the `inspect` feature later on. 

## The `exec` command

Next, lets consider we want to use the container, but we want to use it slightly differently to how the creator intended the container to be run. In this case, we want to use the `exec` command. For example, lets say that I want the container to actually print the text `Hello Mars!`. We could do this by typing the following into the terminal:

```bash
apptainer exec hello-world.sif echo Hello Mars!
Hello Mars!
```

What happened here

* `apptainer`: We called the Apptainer program
* `exec`: This is the execution command for apptainer
* `hello-world.sif`: This is the container we would like to perform a command using. 
* `echo Hello Mars!`: This is the command we would like to perform with our container. 

We could keep doing this for the other planets in the solar system

```bash
apptainer exec hello-world.sif echo Hello Venus!
Hello Venus!
```

## The `shell` command

Now lets consider that we actually want to work with the container interactively. To do this, we use the `shell` command. For example, lets consider that we want to interactively say hello to all the planets in the solar system. 

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
Apptainer> exit
exit
```

Using the `shell` command, we can interactively work inside the container just like we were on a computer/terminal that was built on that container. 

## Exercises

OK, lets consider we have been given a 


!!! graduation-cap "Keypoints"

- Use `apptainer --help` to list all the options available in Apptainer
