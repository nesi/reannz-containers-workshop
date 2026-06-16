# 5. Inspecting, "Editing", and Versioning Containers

!!! clipboard-list "Lesson Objectives"

    - Learn about the `inspect` command
    - Learn how to "edit" containers using the `inspect --deffile` command in Apptainer
    - Remember to version your containers if you make changes

!!! clipboard-question "Questions"

    - How can I find out what an existing container contains and does?
    - Can I change a container after it has been built, and how do I keep track of changes?

The title of this section is a bit of a lie: you cannot actually edit a container once it has been created. What you *can* do is recover the `def` file that was used to build it (the same kind of `def` file you met in the previous section), make additions, removals, and changes to that file, and then rebuild it into a new container.

In this section we focus on "editing" containers in this way, and along the way we learn how to use the `inspect` command and how to version our containers. 

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
user.name@computer-name:~$ apptainer inspect lolcow.sif
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

You will notice that the first three lines of the output stand out from the rest. These are labels that were set in the `%labels` section of the `lolcow.def` script that built the container: 

```bash
%labels
    Author Your Name
    Version 1.0.0
    Description "An apptainer container to run lolcow"
```

The other `org` labels are recorded by Apptainer when it creates the `sif` file. 

And, as we saw in [Chapter 2](02-running-apptainer.md#the-run-command), you can also use this command to learn what the `run` command will do by typing 

```bash
apptainer inspect --runscript
``` 

into the terminal. For example, if you type in:

```bash
apptainer inspect --runscript lolcow.sif
``` 

into the terminal, you will get: 

```bash
user.name@computer-name:~$ apptainer inspect --runscript lolcow.sif
#!/bin/sh

    fortune | cowsay | lolcat
```

## Obtain the `def` file using the `inspect --deffile` command

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
user.name@computer-name:~$ apptainer inspect --deffile lolcow.sif
Bootstrap: docker
From: ubuntu:24.04

%labels
    Author Your Name
    Version 1.0.0
    Description "An apptainer container to run lolcow"

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    fortune | cowsay | lolcat
```

We can now make edits to this file and then rebuild it to create a modified container. For example, consider we want to change `lolcow` so that it says `Hello $1!`, where `$1` means the first argument will be taken when running the container (see the `$1`, `$2`, `$3`, and `$@` section of Chapter 4). 

* In the `%runscript`, we change `fortune | cowsay | lolcat` to `cowsay Hello $1! | lolcat` so the cow greets our argument instead of telling a fortune. Since `fortune` is no longer used, we can also remove it from the `%post` install line.
* Since we are making changes to the container, we record this in the `%labels` section by updating the `Description`.
    * We also bump the `Version`. This is a good idea so we can distinguish the modified container from the original `lolcow`. 

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

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    cowsay Hello $1! | lolcat
```

If we build by typing the following into the terminal (where I have called my modified `def` file [`hellocow.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/05_editing_containers/hellocow.def)):

```bash
apptainer build hellocow.sif hellocow.def
```

We will get a new container that greets whatever argument we give it. For example, running it with `Mars`:

```bash
user.name@computer-name:~$ apptainer run hellocow.sif Mars
 _____________
< Hello Mars! >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

If we `inspect` this new container, we will see that its labels have been updated too. Typing into the terminal:

```bash
apptainer inspect hellocow.sif 
```

We will get:

```bash
user.name@computer-name:~$ apptainer inspect hellocow.sif 
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

For these exercises, assume you have been given the `lolcow.sif` container.

!!! dumbbell "Question 1"

    You have been given `lolcow.sif` but do not know what it does when you run it. How can you find this out *without* actually running the container?

    ??? success "Solution"

        Use `inspect --runscript` to see the command the container runs:

        ```bash
        apptainer inspect --runscript lolcow.sif
        ```

        You can also use `apptainer inspect lolcow.sif` to see its labels (author, version, description) and other metadata.

!!! dumbbell "Question 2"

    How would you recover the `def` file that was used to build `lolcow.sif`, and save it to a file called `lolcow.def`?

    ??? success "Solution"

        Use `inspect --deffile` and redirect the output to a file:

        ```bash
        apptainer inspect --deffile lolcow.sif > lolcow.def
        ```

!!! dumbbell "Question 3"

    Using the `def` file you recovered, you would like to "edit" the container so that it also installs the `figlet` package. Describe the steps you would take to create the modified container.

    ??? success "Solution"

        1. Recover the `def` file (if you have not already):

            ```bash
            apptainer inspect --deffile lolcow.sif > lolcow.def
            ```

        2. Edit `lolcow.def` to add `figlet` to the `%post` section, and update the `%labels` section (bump the `Version` and note the change in the `Description`):

            ```def
            %labels
                Author Your Name
                Version 1.0.1
                Description "lolcow with figlet added"

            %post
                apt-get -y update
                apt-get -y install fortune cowsay lolcat figlet
            ```

        3. Rebuild the container from the edited `def` file:

            ```bash
            apptainer build lolcow_figlet.sif lolcow.def
            ```

!!! dumbbell "Question 4"

    Why is it a good idea to update the `Version` label when you make changes to a container, and how would you check the version of a container you have been given?

    ??? success "Solution"

        Updating the `Version` (and noting the change in the `Description`) lets you tell modified containers apart from the originals, which is important for reproducibility — you and others can see exactly which version produced a given result.

        The version is set in the `%labels` section of the `def` file, and you can check it on a built container with:

        ```bash
        apptainer inspect lolcow.sif
        ```


!!! graduation-cap "Keypoints"

    - Use `apptainer inspect` to view a container's metadata and labels (author, version, description).
    - Use `apptainer inspect --runscript` to see what the container does when you `run` it.
    - Use `apptainer inspect --deffile` to recover the `def` file that built a container.
    - You cannot edit a container in place — instead you recover its `def` file, change it, and rebuild.
    - Always bump the `Version` (and note the change in the `Description`) in `%labels` when you modify a container, to keep your work reproducible.

