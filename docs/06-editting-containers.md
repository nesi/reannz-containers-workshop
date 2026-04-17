# 6. "Editting" Containers

!!! clipboard-list "Lesson Objectives"

    - Learn how to "edit" containers using the `inspect  --deffile` command in Apptainer

Unfortunately the title is a bit of a lie. You can not edit containers once they have been created. However, you can obtain the `def` file from the container. As you can recall from the previous section, the `def` file was used to create the container. From this, you can make some additions, removals, and changes to the container. 

In this section, we will look at how you can "edit" containers. 

## The `inspect` command

This command allows the user to learn about features of the container, such as the architecture the container was built using, and the base the container was built on. If you type in 

```bash
apptainer inspect
```

into the terminal, you will get the following output:

```bash
geoff.weal@login03:~$ apptainer inspect lolcow.sif
org.label-schema.build-arch: amd64
org.label-schema.build-date: Friday_10_April_2026_15:57:1_NZST
org.label-schema.schema-version: 1.0
org.label-schema.usage.apptainer.version: 1.4.5-3.el9
org.label-schema.usage.singularity.deffile.bootstrap: docker
org.label-schema.usage.singularity.deffile.from: ubuntu:24.04
org.opencontainers.image.version: 24.04
```

And, as mentioned previously, you can also use this command to learn what the `run` command will do by typing 

```bash
apptainer inspect --runscript
``` 

into the terminal:

```bash
geoff.weal@login03:~$ apptainer inspect --runscript lolcow.sif
#!/bin/sh

    fortune | cowsay | lolcat
```

## Obtain the `def` file using the `inspect  --deffile` command

**Most importantly for us**, we can also read the `def` file that was used to build this container by typing 

```bash
apptainer inspect --deffile
``` 

into the terminal:

```bash
geoff.weal@login03:/nesi/project/nesi99999/geoffreyweal/Tutorials/containers$ apptainer inspect --deffile lolcow.sif
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%runscript
    fortune | cowsay | lolcat
```

We can now make edits to this file and then rebuild it to create a modified container. For example, consider we want to change `lolcow` so that it says `Hello $1!`, where `$1` means the first argument will be taken when running the container (see section XYZ). To do this, we need to replace `fortune` with `Hello $1!`:

```bash
geoff.weal@login03:/nesi/project/nesi99999/geoffreyweal/Tutorials/containers$ apptainer inspect --deffile lolcow.sif
Bootstrap: docker
From: ubuntu:24.04

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

!!! warning

    From Chris:

    - Should probably also say that this shouldn't be encouraged as it breaks reproducibility?  You could add a section about versioning containers:

    %labels
        Version 1.0.2
        Author YourName

## `--writable-tmpfs`: Another way to add files and packages to Containers

In some cases

