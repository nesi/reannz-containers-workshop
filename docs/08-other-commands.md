# 8. Other Commands in Apptainer

!!! clipboard-list "Lesson Objectives"

    - Learn how to use the `cache`, `test`, and `run-help` commands in Apptainer

In this section, we will wrap up by learning about some subtle but helpful commands that one can use in Apptainer


## The `cache` command

When you pull or build containers, files will be created and placed in the apptainer cache (defined by `APPTAINER_CACHEDIR` in your `~/.bashrc`). You can see what container are in your cache by typing 

```bash
apptainer cache list
```

into the terminal:

```bash
geoff.weal@login03:~$ apptainer cache list
There are 3 container file(s) using 60.62 MiB and 17 oci blob file(s) using 89.48 MiB of space
Total space used: 150.11 MiB
```

Most of the time, these files are unnecessary after you have finished pulling or building your container. You can use the `apptainer cache clean` command to remove the files in your cache

```bash
eoff.weal@login03:~$ apptainer cache clean
This will delete everything in your cache (containers from all sources and OCI blobs).
Hint: You can see exactly what would be deleted by canceling and using the --dry-run option.
Do you want to continue? [y/N] y
INFO:    Removing blob cache entry: blobs
INFO:    Removing blob cache entry: index.json
INFO:    Removing blob cache entry: oci-layout
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/geoffreyweal/apptainer-cache/cache/library
INFO:    Removing oci-tmp cache entry: 5d4e76cf4d780da01cc24a25a7fc4512ae92f728b21cd4b9d06083513476856f
INFO:    Removing oci-tmp cache entry: 6fc11bd6e061e33d59330d0a1a5a73c2aa532c649e0d3514894812deb405b059
INFO:    Removing oci-tmp cache entry: db771bd41359a94a5b9a215e7eca12f67d238327961b99189f8c92c0087d4665
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/geoffreyweal/apptainer-cache/cache/shub
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/geoffreyweal/apptainer-cache/cache/oras
INFO:    No cached files to remove at /nesi/nobackup/nesi99999/geoffreyweal/apptainer-cache/cache/net
```

## The `test` command

You can also provide a test in the container which the user can run to make sure the container works as expected. To do this, you will need to include the `%test` section in your `def` file. For example: 

```bash
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%runscript
    fortune | cowsay | lolcat

%test
    echo "Running container self-tests..."

    # Helper: check command exists and print a friendly message
    check_found () {
        if command -v "$1" >/dev/null 2>&1; then
            echo "$1 was found"
        else
            echo "ERROR: $1 was NOT found"
            exit 1
        fi
    }

    check_found fortune
    check_found cowsay
    check_found lolcat

```

Here, this test to check to make sure that the `fortune`, `cowsay` and `lolcat` packages exist in the container. You can run this test by typing 

```bash
apptainer test lolcow.sif
```

into the terminal:

```bash
geoff.weal@login03:~$ apptainer test lolcow.sif 
Running container self-tests...
fortune was found
cowsay was found
lolcat was found
```

## The `run-help` command

It is possible to give a description of what the container does using the `%help` section of the `def` file. For example, consider the `lolcow` container. We could write the `def` file for this container as:

```bash
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%runscript
    fortune | cowsay | lolcat

%test
    echo "Running container self-tests..."

    # Helper: check command exists and print a friendly message
    check_found () {
        if command -v "$1" >/dev/null 2>&1; then
            echo "$1 was found"
        else
            echo "ERROR: $1 was NOT found"
            exit 1
        fi
    }

    check_found fortune
    check_found cowsay
    check_found lolcat

%help
    This container prints a random fortune using cowsay and colors it with lolcat.

    USAGE:
      apptainer run lolcow.sif

    TEST:
      apptainer test lolcow.sif
```

This container will give the following description when you type

```bash
apptainer run-help lolcow.sif
```

into the terminal:

```bash
geoff.weal@login03:~$ apptainer run-help lolcow.sif
    This container prints a random fortune using cowsay and colors it with lolcat.

    USAGE:
      apptainer run lolcow.sif

    TEST:
      apptainer test lolcow.sif
```

!!! warning

    from chris. 
    There are ways of orchestrating multiple containers in docker using docker swarm or docker compose.  You can do something similar in apptainer using apptainer instance start/stop/list.  It might be worth including.

## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Understand the following commands:
        * `cache`: To check out and remove files in th eapptainer cache.
        * `test`: Allows the user to test the container as designed by the creator of the container. 
        * `run-help`: Allows the creator to provide notes to help explain how to use the container. 
