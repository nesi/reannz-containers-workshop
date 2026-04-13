# 7. Building a Container using Sandbox Mode

!!! clipboard-list "Lesson Objectives"

    - Learn how to use the `cache`, `test`, and `run-help` commands in Apptainer

Sometimes you do not know what you want in your container or how you want to construct it, or sometimes you want the option to be able to modify your container later on. You can do this by using a sandbox in Apptainer. In this section, we will learn what a sandbox is, and use it to construct and later modify a container.


## What is a Sandbox

Apptainer has the option of constructing a sandbox to develop a container rather than writing a `def` file. Here, you perform all the tasks you would like to construct the container manually, but you can make changes to it as you try things out and learn things about how you want your container to act. 


## Advantages and Disadvantages of using a Sandbox

The advantages of using are:

* Sandboxes are writable (mutable).
* Being writable, they are good for debugging. This make changes easier to make
* The filesystem is transparent (because sandboxes are written as files, we will see this later)

However, there are some disadvantages

* Can be a bit tricky to work with.
* You can't use `inspect --deffile` to look at your `%post` instructions on how you created your sandbox.


## Constructing a Container using Sandbox Mode

In this section, we will relook at the `lolcow` container we made earlier and look at how we can create it in sandbox mode.

**First**, you need to build a sandbox that is based on some OS. We do this by typing into the terminal

```bash
apptainer build --sandbox sandbox_name.sandbox base_image
```

where `sandbox_name.sandbox` is the name of your sandbox, and `base_image` is the base of the container (equivalent to `Bootstrap` and `From` in our `def` file). In this case, we will use `docker://ubuntu:24.04` as our base image:

```bash
apptainer build --sandbox lolcow.sandbox docker://ubuntu:24.04
```

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

**Second**, we need to use `shell` to allow us to work inside our sandbox. We do this by typing into the terminal: 

```bash
apptainer shell --writable  --contain --fakeroot sandbox_name.sandbox
```

In our case:

```bash
apptainer shell --writable  --contain --fakeroot lolcow.sandbox
```

```bash
geoff.weal@login03:~$ apptainer shell --writable  --contain --fakeroot lolcow.sandbox
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
INFO:    Using fakeroot command combined with root-mapped namespace
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

Then include what you would like `run` to do inside this `runscript` file:

```bash
#!/bin/sh -e

fortune | cowsay | lolcat
```

**Fourth**, due to a small quirk of how ubuntu works, 

1. The `fortune`, `cowsay`, and `lolcat` programs are found in `/usr/games`. This folder is not pointed to by default in our sandbox. 
2. Some of the locale settings are not automatically given.

These are subtle quirks you would not need to worry about, but are important for getting our `lolcow` program to work. 

Inside the container terminal (the terminal should so `Apptainer>`), do the following:

```bash
mkdir -p /.singularity.d/env
rm -rf /.singularity.d/env/90-runtime.sh
touch /.singularity.d/env/90-runtime.sh
chmod 0755 /.singularity.d/env/90-runtime.sh
nano /.singularity.d/env/90-runtime.sh
```

Then include what you would like `run` to do inside this file:

```bash
# Runtime environment for sandbox (SIF-equivalent)

# Ensure Debian games binaries are visible
export PATH="/usr/games:$PATH"

# Stable, container-safe locale
export LANG=C
export LC_ALL=C

```

**Finally**, we are done with constructing our container sandbox. We can now use Apptainer to turn our sandbox into a container. First, exit out of your container:

```bash
Apptainer> exit
```

Then run in the terminal:

```bash
apptainer build lolcow-from-sandbox.sif lolcow.sandbox 
```

This will give you a `sif` container file called `lolcow-from-sandbox.sif` that you can now use:

```bash
geoff.weal@login03:~$ apptainer run lolcow-from-sandbox.sif
 ________________________________________
/ It has long been an axiom of mine that \
| the little things are infinitely the   |
| most important.                        |
|                                        |
| -- Sir Arthur Conan Doyle, "A Case of  |
\ Identity"                              /
 ----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Making changes to a Sandbox

Sandboxes allow you to make modifications to your container on the fly, such as adding packages or removing packages. Lets consider we want to create a container that gets My Little Ponies to say quotes. We can do this with sandboxes because they are mutable.

**First**, open up our original sandbox in a shell by typing into the terminal:

```bash
apptainer shell --writable  --contain --fakeroot lolcow.sandbox
```

**Second**, we need to install ponysay on our sandbox. You can do this by typing into the terminal:

```bash
echo "Pacific/Auckland" > /etc/timezone
apt-get update
apt-get install -y git python3
apt-get install -y texinfo
cd /opt
git clone https://github.com/erkin/ponysay.git
cd ponysay
python3 setup.py install --freedom=partial
```

**Third**, we will need to rewrite our `runscript` so that it allows for My Little Ponies to give quotes. To do this, open up `runscript` in the terminal:

```bash
nano /.singularity.d/runscript
```

And make sure your `runscript` looks like this:

```bash
#!/bin/sh -e

fortune | ponysay
```

**Forth** (Optional), unfortunately there will be a slightly annoying warning from python when you run `ponysay`. You can prevent it from arising by adding a line to your environment file. In the terminal open `/.singularity.d/env/90-runtime.sh`

```bash
nano /.singularity.d/env/90-runtime.sh
```

Then include what you would like `export PYTHONWARNINGS=ignore` at the bottom of this file: 

```bash
# Runtime environment for sandbox (SIF-equivalent)

# Ensure Debian games binaries are visible
export PATH="/usr/games:$PATH"

# Stable, container-safe locale
export LANG=C
export LC_ALL=C

# Ignore python warnings
export PYTHONWARNINGS=ignore
```

**Fifth**, we are done modifying our sandbox. We can now get Apptainer to turn our sandbox into a container. Exit out of your container

```bash
Apptainer> exit
```

Then run in the terminal:

```bash
apptainer build lolpony-from-sandbox.sif lolcow.sandbox 
```

This will give you a `sif` container file called `lolpony-from-sandbox.sif` that you can now use. Try it out by typing into the terminal:

```bash
apptainer run lolpony-from-sandbox.sif
```

```bash
geoff.weal@login03:~$ apptainer run lolpony-from-sandbox.sif
 _______________________________________________________________ 
/ Grief can take care of itself; but to get the full value of a \
| joy you must                                                  |
| have somebody to divide it with.                              |
\                 -- Mark Twain                                 /
 --------------------------------------------------------------- 
                               \
                                \
                                 \
                              ▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄   
                             ██▄▄██████████▄█▄▄ 
                            ██▄█████▄▄▄█████▄█▀█
                           ██████▄▄▄▄█▄▄▄▄▄▄███ 
                           █▄███▄▄▄▄▄████▄▄ ▀▄██
                           ███▄▄█▄▄██▄██▄█▄   ██
                           ██▄▄█████▄████▄█    ▀
             ▄▄▄▄▄▄         ██▄▄█▄▄██▄█▄█▄█     
          ▄▄▄██████▄▄▄      ███▄▄███████▄▄▀     
         ▄▄███████▄▄▄▄▄▄▄▄▄▄▄█▄▄▄▄██▀▀▀▀        
       ▄▄█▄███████ ▄▄▄█▄▄▄▄██▄██▄███            
       █▀█████████ ██▄█▄█▄▄█▄▄█▄██▄▀            
        ▄▄████████ ▀▄▄▄███▄▄▄▄▄▄█▄▀             
      ▄▄██████▄▀█  ▄███▄█▄▄▄▄██▄▄█              
   ▄▄▄████▄███    █████▄▄▀  ██████              
 ▀▀▄▄▄▄▄▄▄█▄▀     ███████   ███▄▄▄▄             
      ▄█▄▀▀      ████████   ███████             
                 ████████   ████▄▄██▄           
                ██████▄▄█   ██████▄▄█           
                █▄▄▄▄█       █▄▄▄▄█             

```


## Advice for using Sandboxes

Sandboxes are great when you want to muck around and play with your container without having to rewrite and build several `def` files over and over. However, it is worth noting that `def` files are very useful as they provide all the infromation needed to write a container from scratch (particularly due to their `%post` section):

Therefore, here are some pointer for using sandboxes:

* As you are using sandboxes, write down what worked in the `%post` section of the `def` file. Once you have something working, use the `def` file to build your production-grade container.
* If you need to modify your container further, you can always use the information from the `def` file to create a new sandbox from which you can make further modifications to. 
    * Again, write your successful steps in the `%post` section of the `def` file.

## Exercises

!!! dumbbell "Question 1"

    

## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Understand the following commands:
        * `cache`: To check out and remove files in th eapptainer cache.
        * `test`: Allows the user to test the container as designed by the creator of the container. 
        * `run-help`: Allows the creator to provide notes to help explain how to use the container. 
