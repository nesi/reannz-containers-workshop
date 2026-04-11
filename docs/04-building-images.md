# 4. Building Containers

!!! clipboard-list "Lesson Objectives"

    - Know how to write a def file
    - Use the `build` command to build a container


It is often very useful to be able to build your own containers. This is because you might want to:

* Create an environment with toolchains that don't exist or don't exist exactly as you need them on Mahuika
* Want to create environments that are transferable to other scientist on other HPC systems

Here, we will learn how to build a container using Apptainer from a script called a definition file, known as a `def` file. 

## 1. Creating a `def` (Definition) File

A `def` file is a simple script that contains information about how to construct a container and what the container should do. A complete skeleton of a `def` file looks as follows:


```def
Bootstrap: 
From: 

%post

%runscript

```

In this section, we will write a `def` file containing the most important sections 

### The `Bootstrap` and `From` Section

To build a container, you need a base to build it on. `Bootstrap` and `From` allow apptainer to pull the base that you desire:

* `Bootstrap` : The cloud that the base of the container comes from.
* `From` : What is the name of the base you want to pull from the `Bootstrap` cloud.

If you dont include these, the base will be built on the OS of the computer that you build the container on. 

For example, if I wanted to build the container based on Ubuntu 22.04, I would include the following in the `Bootstrap` and `From` sections of the `def` file:

```def
Bootstrap: docker
From: ubuntu:22.04
```

### The `%post` Section

This section allows you to build your container the way you want it and install all the programs and packages that you want your container to contain. 

For example, if I wanted to create a container that contained Python 3.12 (as well as all the other packages that Python needs), I could write it like so (Note: there are many ways one could write this `def` file. This is just one of those ways):

```def
%post
    # Prevent any interactive prompts
    export DEBIAN_FRONTEND=noninteractive

    # Set timezone explicitly
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
    echo "Etc/UTC" > /etc/timezone

    # Install build dependencies for Python
    apt-get update && apt-get install -y \
        build-essential \
        wget \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        liblzma-dev \
        tk-dev \
        ca-certificates \
        xz-utils \
        && rm -rf /var/lib/apt/lists/*

    # Download Python 3.12 source
    cd /tmp
    wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz
    tar -xzf Python-3.12.2.tgz
    cd Python-3.12.2

    # Configure, build, and install
    ./configure --enable-optimizations
    make -j$(nproc)
    make altinstall

    # Ensure python3 and pip point to 3.12
    ln -sf /usr/local/bin/python3.12 /usr/local/bin/python3
    ln -sf /usr/local/bin/pip3.12 /usr/local/bin/pip3

    # Clean up build artifacts
    cd /
    rm -rf /tmp/Python-3.12.2*
```

### The `%runscript` Section

This algorithm is responsible for determining what happens when you perform `apptainer run`. This is optional, as you could always execute your container using `apptainer exec`. For example:

```def
%runscript
    python3.12 -c 'print("hello world")'
```

## 2. Build your Container

Now that we have the basics of our `.def` file, we can now build our container using `apptainer build`:

```bash
apptainer build <name-of-sif-file> <name-of-def-file>
```

Example: 

```bash
geoff.weal@login03:$ apptainer build my_python3.12.sif my_python3.12.def
INFO:    User not listed in /etc/subuid, trying root-mapped namespace
INFO:    The %post section will be run under the fakeroot command
INFO:    Starting build...
INFO:    Fetching OCI image...
28.4MiB / 28.4MiB [===================================================================================================] 100 % 0.0 b/s 0s
INFO:    Extracting OCI image...
INFO:    Inserting Apptainer configuration...
INFO:    Running post scriptlet
+ apt-get update
...
Looking in links: /tmp/tmppt4k91m6
Processing /tmp/tmppt4k91m6/pip-24.0-py3-none-any.whl
Installing collected packages: pip
Successfully installed pip-24.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
+ ln -sf /usr/local/bin/python3.12 /usr/local/bin/python3
+ ln -sf /usr/local/bin/pip3.12 /usr/local/bin/pip3
+ cd /
+ rm -rf /tmp/Python-3.12.2 /tmp/Python-3.12.2.tgz
INFO:    Adding runscript
INFO:    Creating SIF file...
```

## 3. Run or Execute your Container

You can now run your container using `apptainer run <name-of-your-sif-file>`. For example: 

```bash
geoff.weal@login03:$ apptainer run my_python3.12.sif
hello world
```

We can also use the `exec` command to run python3.12 to say "Hello Sun!"

```bash
apptainer exec my_python3.12.sif python3.12 -c 'print("Hello Mars!")' 
Hello Mars!
```

## Other Useful Tips and Tricks

### Using the `$1`, `$2`, `$3`, and `$@` symbols in `apptainer run`

Sometimes you want to pass an command into the `apptainer run` command so you can easily do different things. To do this, we use the `@` symbol. For example, lets consider that we want to write a container that will say hello to some input planet. We could write the following `def` file:

```def
Bootstrap: docker
From: ubuntu:22.04

%runscript
    echo Hello $1!
```

We can now run this container and give it 1 input for a planet we want to say hello to:

```bash
apptainer build tip1.sif tip1.def 
apptainer run tip1.sif Mars
Hello Mars!
```

We could now build a container than allows us to say hello to three planets. We can do this by using `$1`, `$2`, and `$3`:

```def
Bootstrap: docker
From: ubuntu:22.04

%runscript
    echo Hello $1, $2, and $3!
```

Doing this gives:

```bash
apptainer build tip2.sif tip2.def 
apptainer run tip2.sif Mercury Venus Earth
Hello Mercury, Venus, and Earth!
```

Finally, maybe we dont want to have any sort of limit to the nummber of planets that we say hello to. In this case, we can use the `$@` symbol which will access all arguments (inputs) given to `apptainer run`. For example, consider the following `def` file:

```def
Bootstrap: docker
From: ubuntu:22.04

%runscript
    echo Hello $@!
```

If we run this script, giving the input as `Mercury Venus Earth Mars Jupiter Saturn Neptune`, we will get: 

```bash
apptainer build tip3.sif tip3.def 
apptainer run tip3.sif Mercury Venus Earth Mars Jupiter Saturn Neptune
Hello Mercury Venus Earth Mars Jupiter Saturn Neptune!
```

## Exercises

!!! dumbbell "Question 1"

    Write a `def` file that will allows the user build a container that runs `lolcow` from their terminal.

    Hint: The instructions for building lolcow are:

    ```bash
    apt-get -y update
    apt-get -y install fortune cowsay lolcat
    ```

    and the way you run lolcow is by doing the following in the terminal:

    ```bash
    fortune | cowsay | lolcat
    ```

    ??? success "Solution"

        The def file for `lolcow` is:

        ```bash
        Bootstrap: docker
        From: ubuntu:24.04

        %post
            apt-get -y update
            apt-get -y install fortune cowsay lolcat

        %runscript
            fortune | cowsay | lolcat
        ```

!!! dumbbell "Question 2"

    Using the answer from Question 1, how would you build and run the `lolcow` container?

    ??? success "Solution"

        Type into the terminal:

        ```bash
        apptainer build lolcow.sif lolcow.def
        ```

        You will see something like this as the `lolcow` container is being built:

        ```bash
        geoff.weal@login03:~$ apptainer build lolcow.sif lolcow.def
        INFO:    User not listed in /etc/subuid, trying root-mapped namespace
        INFO:    The %post section will be run under the fakeroot command
        INFO:    Starting build...
        INFO:    Fetching OCI image...
        28.4MiB / 28.4MiB [================================================================================================================================================================================] 100 % 9.4 MiB/s 0s
        INFO:    Extracting OCI image...
        INFO:    Inserting Apptainer configuration...
        INFO:    Running post scriptlet
        + apt-get -y update
        ...
        done.
        INFO:    Adding environment to container
        INFO:    Adding runscript
        INFO:    Creating SIF file...
        [============================================================================================================================================================================================================] 100 % 0s
        INFO:    Build complete: lolcow.sif
        ```

        You can then run the `lolcow` container by running in the terminal

        ```bash
        apptainer run lolcow.sif
        ```

        This will give an output like this:

        ```bash
        geoff.weal@login03:~$ apptainer run lolcow.sif
         ________________________________________
        / No violence, gentlemen -- no violence, \
        | I beg of you! Consider the furniture!  |
        |                                        |
        \ -- Sherlock Holmes                     /
         ----------------------------------------
                \   ^__^
                 \  (oo)\_______
                    (__)\       )\/\
                        ||----w |
                        ||     ||
        ```

!!! dumbbell "Question 3"

    Using the skills you have learnt in this tutorial, create your own container for running a program that would be useful for you on Mahuika. 

## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - Can write a `def` file that apptainer can use to build a container, including the:
        - `Bootstrap` and `From` sections for downloading the base of the container
        - `%post` section for customising what is built when building the container.
        - `%runscript` section for write the desired command you would commonly want the user to run when using the container.
    - Understand how to use the `build` command for building a container from the `def` file
    - Know how to include `$1`, `$2`, `$3`, and `$@` symbols in `%runscript` so the user can pass arguments into `apptainer run`









