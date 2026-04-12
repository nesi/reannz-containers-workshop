# 7. Building a Container using Sandbox Mode

!!! clipboard-list "Lesson Objectives"

    - Learn how to use the `cache`, `test`, and `run-help` commands in Apptainer

Sometimes you do not know what you want in your container or how you want to construct it, or sometimes you want the option to be able to modify your container later on. You can do this by using a sandbox in Apptainer. In this section, we will learn what a sandbox is, and use it to construct and later modify a container.

## What is a sandbox

Apptainer has the option of constructing a sandbox to develop a container rather than writing a `def` file. Here, you perform all the tasks you would like to construct the container manually, but you can make changes to it as you try things out and learn things about how you want your container to act. 

## Constructing a Container using Sandbox Mode

In this section, we will relook at the `lolcow` container we made earlier and look at how we can create it in sandbox mode.

**First**, you need to build a sandbox that is based on some OS. We do this by typing `apptainer build --sandbox lolcow.sandbox base_image`

where `base_image` is the base of the container, equivalent to `Bootstrap` and `From` in our `def` file. In this case, we will use `docker://ubuntu:24.04` as our base image:

```bash
geoff.weal@login03:~$ apptainer build --sandbox lolcow.sandbox docker://ubuntu:24.04
INFO:    Starting build...
INFO:    Fetching OCI image...
28.4MiB / 28.4MiB [====================================================================================================================================================================================================================================================] 100 % 0.0 b/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Creating sandbox directory...
INFO:    Build complete: lolcow.sandbox
```

**Second**, we need to use `shell` to allow us to work inside our sandbox. We do this by typing `apptainer shell --writable --fakeroot sandbox_name.sandbox` into the terminal, where `sandbox_name.sandbox` is the name of your sandbox. In our case:

```bash
geoff.weal@login03:~$ apptainer shell --writable --fakeroot lolcow.sandbox
WARNING: Skipping mount /etc/localtime [binds]: /etc/localtime doesn't exist in container
Apptainer> 
```

We can now install the packages for `lolcow` we would like using the apptainer shell (we will also install `nano` for later). 

```bash
apt-get -y update
apt-get -y install fortune cowsay lolcat
apt-get -y install nano 
```

This is equivalent to writing the `%post` command manually into the sandbox:

```bash
geoff.weal@login03:~$ apptainer shell --writable --contain --fakeroot lolcow.sandbox
Apptainer> apt-get -y update
Get:1 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB] 
...
Reading package lists... Done
Apptainer> apt-get -y install fortune cowsay lolcat
Reading package lists... Done
...
done.
Apptainer> apt-get -y install nano
Reading package lists... Done
...
done.
Apptainer> 
```

**Third**, while we are still inside the container, we can write files that determine what `run` does. Inside the container terminal (the terminal should so `Apptainer>`), do the following:

```bash
mkdir -p /.singularity.d
rm -rf /.singularity.d/runscript
touch /.singularity.d/runscript
chmod 0755 /.singularity.d/runscript
nano /.singularity.d/runscript
```

**NOTE**: To use `nano` inside the container, you will need to install `nano` by typing `apt-get -y install nano` into the container's terminal

Then include what you would like `run` to do inside this file:

```bash
#!/bin/sh -e

fortune | cowsay | lolcat
```

**Forth**, if we are done with constructing our container sandbox, we can get Apptainer to turn our sandbox into a container. First, exit out of your container

```bash
Apptainer> exit
```

Then run in the terminal:

```bash
apptainer build lolcow-from-sandbox.sif lolcow.sandbox 
```

This will give you a `sif` container file called `lolcow-from-sandbox.sif` that you can now use:










## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Understand the following commands:
        * `cache`: To check out and remove files in th eapptainer cache.
        * `test`: Allows the user to test the container as designed by the creator of the container. 
        * `run-help`: Allows the creator to provide notes to help explain how to use the container. 
