# 3. Pulling and Running Containers from the Cloud

!!! clipboard-list "Lesson Objectives"

    - Pull a container from the cloud
    - Run a container that is on the cloud

Sometimes you might not have a container file sitting in front of you that you want to use. Most of the time, your container might be sitting on the internet somewhere, like in docker. There are two ways you can interact with containers that are on the cloud:

1. Pull the image from the cloud first using `pull`, then run the container directly from the computer, or 
2. Run the container directly using the `run`, `exec`, or `shell` command. 

In this lesson, we will look at both of these methods.

## Pulling containers using the `pull` command

You can pull a container from the cloud by performing the following command: 

```bash
apptainer pull output_name.sif <URI>
```

where:

* `output_name.sif`: Is the name you want to give to the container you pull/download
* `<URI>`: This is the URL to download the container from.

!!! note
    
    Pulling a container just means downloading a container from the internet.

For example, consider that we want to pull a container that contains Alpine, which is a very light-weight OS system. To do this, we can type into the terminal: 

```bash
apptainer pull my_alpine.sif docker://alpine
```

If you do this in the terminal, you will see the following:

```bash
geoff.weal@login03:$ apptainer pull my_alpine.sif docker://alpine
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
INFO:    Fetching OCI image...
3.7MiB / 3.7MiB [=============================================================================] 100 % 242.0 KiB/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Creating SIF file...
[=========================================================================================================] 100 % 0s
```

What you can see is apptainer is downloading and contructing the container on your computer. We can now see that we have made a file called `my_alpine.sif`:

```bash
geoff.weal@login03:$ ls
my_alpine.sif
```

We can now use `exec` or `shell` to run Unix commands on the container:

Performing the `exec` in the `my_alpine.sif` container, we see:

```bash
apptainer exec my_alpine.sif echo Hello World!
Hello World!
```

Performing the `shell` in the `my_alpine.sif` container, we see:


```bash
geoff.weal@login03:$ apptainer shell my_alpine.sif
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

## Running a container directly from the cloud

You can also skip the pull step entirely if you do not want to directly download the container onto your computer. You can do this by using the `run`, `exec` or `shell` command, where you call the address of the container on the cloud rather than the `sif` file.

For example, consider that we want to perform `Hello World!` on the alpine container directly, rather than pulling it first then running it. To do this, we would do the following in the terminal:

```bash
apptainer exec docker://alpine echo Hello World!
```

See that we have replaced `my_alpine.sif` from the previous section with `docker://alpine`. Doing this will give the following:

```bash
geoff.weal@login03:~$ apptainer exec docker://alpine echo Hello World!
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
INFO:    Fetching OCI image...
3.7MiB / 3.7MiB [================================================================================================================================================================================] 100 % 517.2 KiB/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Creating SIF file...
[============================================================================================================================================================================================================] 100 % 0s
Hello World!
```

or if you have already download alpine once before, you may get the image straight from the cache:

```bash
geoff.weal@login03:~$ apptainer exec docker://alpine echo Hello World!
INFO:    Using cached SIF image
Hello World!
```

Following this, if you want to `shell` in the `docker://alpine` container, we see:

```bash
geoff.weal@login03:~$ apptainer shell docker://alpine
INFO:    Using cached SIF image
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

In this case, I am using the version of alpine that is currently stored in the apptainer cache.

## Exercises

!!! dumbbell "Question 1"

    How would you pull the image `docker://python:3.14-alpine` from docker?

    ??? success "Solution"

        Type into the terminal

        ```bash
        apptainer pull my_python3.14.sif docker://python:3.14-alpine
        ```

        where I have chosen to call this container `my_python3.14.sif`:

        ```bash
        geoff.weal@login03:~$ apptainer pull my_python3.14.sif docker://python:3.14-alpine
        INFO:    Converting OCI blobs to SIF format
        INFO:    Starting build...
        INFO:    Fetching OCI image...
        12.8MiB / 12.8MiB [==================================================================================================================================================================================] 100 % 0.0 b/s 0s
        3.7MiB / 3.7MiB [====================================================================================================================================================================================] 100 % 0.0 b/s 0s
        450.0KiB / 450.0KiB [================================================================================================================================================================================] 100 % 0.0 b/s 0s
        INFO:    Extracting OCI image...
        INFO:    Inserting Apptainer configuration...
        INFO:    Creating SIF file...
        [============================================================================================================================================================================================================] 100 % 0s
        ```


!!! dumbbell "Question 2"

    How can I directly run python from the cloud image `docker://python:3.14-alpine` using the `run`?

    ??? success "Solution"

        Type into the terminal

        ```bash
        apptainer run docker://python:3.14-alpine
        ```

        where I have chosen to call this container `my_python3.14.sif`:

        ```bash
        geoff.weal@login03:~$ apptainer run docker://python:3.14-alpine
        INFO:    Using cached SIF image
        Python 3.14.4 (main, Apr  8 2026, 17:40:50) [GCC 15.2.0] on linux
        Type "help", "copyright", "credits" or "license" for more information.
        >>> print('Hello Earth!')
        Hello Earth!
        >>> exit()
        ```

        In this case, because I have already downloaded the `docker://python:3.14-alpine` image once before, apptainer is using the cached version of `docker://python:3.14-alpine`.


## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Can pull a container from the cloud using the `pull` command
    - Can run a container directly from the cloud using `run`, `exec`, or `shell`
