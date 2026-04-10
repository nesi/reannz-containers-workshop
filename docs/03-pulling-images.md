# 3. Pulling and Running Containers from the Cloud

!!! clipboard-list "Lesson Objectives"

    - Pull a container from the internet

!!! clipboard-question "Questions"

    - How do I pull an images and use it.


Sometimes you might not have a container file sitting in front of you that you want to use. Most of the time, your container might be sitting on the internet somewhere, like in docker, that you want to use. 

There are two ways you can interact with these containers that are on the cloud:

1. Pull the image from the cloud first using `pull`, then run the container directly from the computer, or 
2. Run the container directly using the `run`, `exec`, or `shell` command. 

## Pulling (Downloading) Containers using the `pull` command

Note: Pulling a container just means downloading a container from the internet.

You can pull a container from the internet or the cloud by performing the following command

```bash
apptainer pull output_name.sif <URI>
```

Where:

* `output_name.sif`: Is the name you want to give to the container you pull/download
* `<URI>`: This is the URL to download the container from.

For example, consider that we want to pull a container that contains Alpine, which is a very light-weight OS system. To do this, we can type into the terminal: 

```bash
apptainer pull my_alpine.sif docker://alpine
INFO:    Converting OCI blobs to SIF format
INFO:    Starting build...
INFO:    Fetching OCI image...
3.7MiB / 3.7MiB [=============================================================================] 100 % 242.0 KiB/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Creating SIF file...
[=========================================================================================================] 100 % 0s
```

We can now see that we have made a file called `my_alpine.sif`:

```bash
geoff.weal@login03:$ ls
my_alpine.sif
```

We can now use `exec` or `shell` to run Unix commands on the container:

```bash
apptainer exec my_alpine.sif echo Hello World!
Hello World!
```

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

## Exercises







!!! graduation-cap "Keypoints"

- Use `apptainer --help` to list all the options available in Apptainer
