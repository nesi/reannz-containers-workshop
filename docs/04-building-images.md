# 4. Building Containers

!!! clipboard-list "Lesson Objectives"

    - Know how to write a def file
    - Use the `build` command to build a container

!!! clipboard-question "Questions"

    - How 

It is often very useful to be able to build your own containers to perform tasks. This is because you might want to:

* Create an environment with toolchains that don't exist or exist exactly as you need them on Mahuika
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

To build a container you need a base to build it on. `Bootstrap` and `From` allow apptainer to pull the base that you desire

* `Bootstrap:` : The website that the base of the container comes from
* `From:` : Related to `Bootstrap:`, what is the name of the base.

If you dont include these, the base of your container will be built from the OS of the computer you build your container on. 

Example: 

```def
Bootstrap: docker
From: ubuntu:22.04
```

### The `%post` Section

This section allows you to build your container how you would like to and install all the programs and packages that you want your container to contain. 

Example:

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

This algorithm is responsible for determining what happens when you perform `apptainer run`. This is optional, as you could always execute your container using `apptainer exec`.

Example:

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

You can now run your container using `apptainer run <name-of-your-sif-file>`

Example: 

```bash
geoff.weal@login03:$ apptainer run my_python3.12.sif
hello world
```

We can also use the `exec` command to run python3.12 to say "Hello Sun!"

```bash
apptainer exec my_python3.12.sif python3.12 -c 'print("Hello Mars!")' 
Hello Mars!
```

## Other Tips and Skills for Building Containers

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


## Extra for those Interested


Other sections of the `def` file (optional): 

* `%arguments`: These are variables that are referred to during a build
* `%setup`: 
* `%files`
* `%environment`
* `%post`
* `%runscript`
* `%startscript`
* `%test`
* `%labels`
* `%help`























An example of a `def` file is shown below:

```def
Bootstrap: docker
From: ubuntu:{{ VERSION }}
Stage: build

%arguments
    VERSION=22.04

%setup
    touch /file1
    touch ${APPTAINER_ROOTFS}/file2

%files
    /file1
    /file1 /opt

%environment
    export LISTEN_PORT=54321
    export LC_ALL=C

%post
    apt-get update && apt-get install -y netcat
    NOW=`date`
    echo "export NOW=\"${NOW}\"" >> $APPTAINER_ENVIRONMENT

%runscript
    echo "Container was created $NOW"
    echo "Arguments received: $*"
    exec echo "$@"

%startscript
    nc -lp $LISTEN_PORT

%test
    grep -q NAME=\"Ubuntu\" /etc/os-release
    if [ $? -eq 0 ]; then
        echo "Container base is Ubuntu as expected."
    else
        echo "Container base is not Ubuntu."
        exit 1
    fi

%labels
    Author myuser@example.com
    Version v0.0.1

%help
    This is a demo container used to illustrate a def file that uses all
    supported sections.
```

Note that this is a very complete `def` file which makes it look overwhelming. In general, you do not need to include all these features. We show it here just so we can describe all the features you can include in a `def` file. 





!!! graduation-cap "Keypoints"

- Use `apptainer --help` to list all the options available in Apptainer
