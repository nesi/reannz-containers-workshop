# 5. Inspecting, "Editting", and Versioning Containers

!!! clipboard-list "Lesson Objectives"

    - Learn about the `inspect` command
    - Learn how to "edit" containers using the `inspect  --deffile` command in Apptainer
    - Remember to version your containers if you make changes

Here, we will be learning about the `inspect` command and giving versions to your containers. However, unfortunately, the title is a bit of a lie. You can not edit containers once they have been created. However, you can obtain the `def` file from the container. As you can recall from the previous section, the `def` file was used to create the container. From this, you can make some additions, removals, and changes to the container. 

In this section, we will primarily focus on how you can "edit" containers, with added learning about using the `inspect` command and versioning your containers. 

!!! warning

    It is not recommended to "edit" containers in this way as it can break reproducibility. However it can be useful to consider this if you are having problems with a container.

    * If you do this, always version your container. 

## The `inspect` command

This command allows the user to learn about features of the container, such as the architecture the container was built using, and the base the container was built on. This command is: 

```bash
apptainer inspect
```

For example, if you type in: 

```bash
apptainer inspect lolcow.sif
```

into the terminal, you will get the following output:

```bash
geoff.weal@login03:~$ apptainer inspect lolcow.sif
Author: Your Name
Description: "An apptainer container to run lolcow"
Version: 1.0.0
org.label-schema.build-arch: amd64
org.label-schema.build-date: Saturday_18_April_2026_12:42:40_NZST
org.label-schema.schema-version: 1.0
org.label-schema.usage.apptainer.version: 1.4.5-3.el9
org.label-schema.usage.singularity.deffile.bootstrap: docker
org.label-schema.usage.singularity.deffile.from: ubuntu:24.04
org.opencontainers.image.version: 24.04
```

You will notice the first three lines of `apptainer inspect lolcow.sif` stand out a bit. These are labels that have been given in the `lolcow.def` script. We will see this later on in this lesson: 

```bash
%labels
    Author Your Name
    Version 1.0.0
    Description "An apptainer container to run lolcow"
```

The other `org` labels are recorded by apptainer when it creates the `sif` file. 

And, as mentioned previously, you can also use this command to learn what the `run` command will do by typing 

```bash
apptainer inspect --runscript
``` 

into the terminal. For example, if you type in:

```bash
apptainer inspect --runscript lolcow.sif
``` 

into the terminal, you will get: 

```bash
geoff.weal@login03:~$ apptainer inspect --runscript lolcow.sif
#!/bin/sh

    fortune | cowsay | lolcat
```

## Obtain the `def` file using the `inspect  --deffile` command

**Most importantly for us**, we can also read the `def` file that was used to build this container by using the command:  

```bash
apptainer inspect --deffile
``` 

For example, if you do this in the terminal:

```bash
apptainer inspect --deffile lolcow.sif
```

You should see this:

```bash
geoff.weal@login03:~$ apptainer inspect --deffile lolcow.sif
Bootstrap: docker
From: ubuntu:24.04

%labels
    Author Your Name
    Version 1.0.0
    Description "An apptainer container to run lolcow"

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%runscript
    fortune | cowsay | lolcat
```

We can now make edits to this file and then rebuild it to create a modified container. For example, consider we want to change `lolcow` so that it says `Hello $1!`, where `$1` means the first argument will be taken when running the container (see section XYZ). 

* To do this, we need to replace `fortune` with `Hello $1!` (we can also remove installing `fortune` in the `%post` section):
* Since we are making changes to the lolcow container, we should record this in the `%labels` section by making a note of this in the `Description` section. 
    * We can also change the version of the container if we want. This is generally a good idea so we can distinguish it from previous versions of `lolcow` or `hellocow`. 

```def
Bootstrap: docker
From: ubuntu:24.04

%labels
    Author Your Name
    Version 1.0.1
    Description "An apptainer container to run hellocow. Note: This is a modification of lolcow"

%post
    apt-get -y update
    apt-get -y install cowsay lolcat

%runscript
     cowsay Hello $1! | lolcat
```

If we build by typing the following into the terminal (where I have called my modified `def` file `hellocow.def`):

```bash
apptainer build hellocow.sif hellocow.def
```

We will get a new container that now will show a cow saying `Hello Argument1!`:

```bash
geoff.weal@login03:~$ apptainer run hellocow.sif Mars
 _____________
< Hello Mars! >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

If we `inspect` this container, we will see that we have also updated it's labels. Typing into the terminal:

```bash
apptainer inspect hellocow.sif 
```

We will get:

```bash
geoff.weal@login03:~$ apptainer inspect hellocow.sif 
Author: Your Name
Description: "An apptainer container to run hellocow. Note: This is a modification of lolcow"
Version: 1.0.1
org.label-schema.build-arch: amd64
org.label-schema.build-date: Saturday_18_April_2026_13:16:40_NZST
org.label-schema.schema-version: 1.0
org.label-schema.usage.apptainer.version: 1.4.5-3.el9
org.label-schema.usage.singularity.deffile.bootstrap: docker
org.label-schema.usage.singularity.deffile.from: ubuntu:24.04
org.opencontainers.image.version: 24.04
```

## Exercises

!!! dumbbell "Question 1"

    Example


## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Point 1

