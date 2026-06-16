# S2: Other Commands in Apptainer

!!! clipboard-list "Lesson Objectives"

    - Learn how to use the `cache` and `run-help` commands in Apptainer.

!!! clipboard-question "Questions"

    - How do I see and clean up the files Apptainer stores when I pull or build containers?
    - How can the creator of a container provide built-in usage notes?

In this section we look at a couple of subtle but helpful commands that Apptainer provides: `cache` and `run-help`.

## The `cache` command

When you pull or build containers, files will be created and placed in the Apptainer cache (defined by `APPTAINER_CACHEDIR` in your `~/.bashrc`). You can see what containers are in your cache by typing 

```bash
apptainer cache list
```

into the terminal:

```bash
user.name@computer-name:~$ apptainer cache list
There are 3 container file(s) using 60.62 MiB and 17 oci blob file(s) using 89.48 MiB of space
Total space used: 150.11 MiB
```

Most of the time, these files are unnecessary after you have finished pulling or building your container. You can use the `apptainer cache clean` command to remove the files in your cache

```bash
user.name@computer-name:~$ apptainer cache clean
This will delete everything in your cache (containers from all sources and OCI blobs).
Hint: You can see exactly what would be deleted by canceling and using the --dry-run option.
Do you want to continue? [y/N] y
INFO:    Removing blob cache entry: blobs
INFO:    Removing blob cache entry: index.json
INFO:    Removing blob cache entry: oci-layout
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/username/apptainer-cache/cache/library
INFO:    Removing oci-tmp cache entry: 5d4e76cf4d780da01cc24a25a7fc4512ae92f728b21cd4b9d06083513476856f
INFO:    Removing oci-tmp cache entry: 6fc11bd6e061e33d59330d0a1a5a73c2aa532c649e0d3514894812deb405b059
INFO:    Removing oci-tmp cache entry: db771bd41359a94a5b9a215e7eca12f67d238327961b99189f8c92c0087d4665
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/username/apptainer-cache/cache/shub
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/username/apptainer-cache/cache/oras
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/username/apptainer-cache/cache/net
```

## The `run-help` command

It is possible to give a description of what the container does using the `%help` section of the `def` file. For example, consider the `lolcow` container. We could write the `def` file for this container as:

```def
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%runscript
    fortune | cowsay | lolcat

%help
    This container prints a random fortune using cowsay and colors it with lolcat.

    USAGE:
      apptainer run lolcow.sif
```

This container will give the following description when you type

```bash
apptainer run-help lolcow.sif
```

into the terminal:

```bash
user.name@computer-name:~$ apptainer run-help lolcow.sif
    This container prints a random fortune using cowsay and colors it with lolcat.

    USAGE:
      apptainer run lolcow.sif
```

!!! graduation-cap "Keypoints"

    - Understand the following commands:
        * `cache`: to list and remove files in the Apptainer cache.
        * `run-help`: lets the creator provide notes explaining how to use the container.
