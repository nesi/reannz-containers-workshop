# 7. Building a Container using Sandbox Mode

!!! clipboard-list "Lesson Objectives"

    - Learn the concept of sandboxes.
    - Understand when it is appropriate to use one over a `def` file.
    - Know how to construct and work with a sandbox.
    - Understand how to convert a sandbox into a container.

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

**Side-note**: You will see in your directory a folder appear called `sandbox_name.sandbox` (for us, that is `lolcow.sandbox`):

```bash
geoff.weal@login03:~$ ls
lolcow.sandbox
```

if you look inside of it, it will look a full fat file system containing everything you need to run the sandbox as a container, as well as eventually turn the sandbox into a container (see later).

```bash
geoff.weal@login03:~$ ls lolcow.sandbox
bin  boot  dev  environment  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  singularity  srv  sys  tmp  usr  var
```

**Second**, we need to use `shell` to allow us to work inside our sandbox. We do this by typing into the terminal: 

```bash
apptainer shell --writable --contain --fakeroot sandbox_name.sandbox
```

In our case:

```bash
apptainer shell --writable --contain --fakeroot lolcow.sandbox
```

```bash
geoff.weal@login03:~$ apptainer shell --writable --contain --fakeroot lolcow.sandbox
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

!!! note

    At this point, it is a good idea to see if your container will work by typing in the environment and runscript you gave to the container into the `shell`.

    Try this out by typing into the container's terminal:

    ```bash
    # Ensure Debian games binaries are visible
    export PATH="/usr/games:$PATH"

    # Stable, container-safe locale
    export LANG=C
    export LC_ALL=C
    ```

    then:

    ```bash
    fortune | cowsay | lolcat
    ```

    Hopefully, you should see something happen!

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

!!! note

    At this point, it is a good idea to see if your container will work by typing in the environment and runscript you gave to the container into the `shell`.

    Try this out by typing into the container's terminal:

    ```bash
    # Ensure Debian games binaries are visible
    export PATH="/usr/games:$PATH"

    # Stable, container-safe locale
    export LANG=C
    export LC_ALL=C

    # Ignore python warnings
    export PYTHONWARNINGS=ignore
    ```

    then:

    ```bash
    fortune | ponysay
    ```

    Hopefully, you should see something happen!

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

    A student want to run GROMACS in a container, but doesn't know what version they want to use. The student knows the protocol for installing GROMACS 2021.6 on Ubuntu 22.04, which is: 

    ```bash
    # Update Ubuntu
    apt-get update

    # Set the locate for date
    echo "Pacific/Auckland" > /etc/timezone

    # Install necessary packages
    apt-get install -y \
      build-essential \
      cmake \
      wget \
      python3 \
      libfftw3-dev \
      libgsl-dev \
      ca-certificates 

    # Download and install GROMACS 2021.6
    cd /opt
    wget https://ftp.gromacs.org/gromacs/gromacs-2021.6.tar.gz
    tar -xzf gromacs-2021.6.tar.gz
    cd gromacs-2021.6


    # Configure GROMACS 2021.6
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gromacs -DGMX_BUILD_OWN_FFTW=OFF -DGMX_MPI=OFF -DGMX_OPENMP=ON -DGMX_GPU=OFF -DGMX_USE_CUDA=OFF

    # Build and install GROMACS 2021.6
    make -j8
    make install

    # Remove unnecessary GROMACS files after installation
    cd /opt
    rm -rfv gromacs-2021.6.tar.gz gromacs-2021.6
    ```

    GROMACS also need the following environment to run:

    ```bash
    # GROMACS environment
    source /opt/gromacs/bin/GMXRC
    ```

    Use a sandbox to create this container as a `sif` file. Show that it works by running `apptainer exec gmx --version`.

    ??? success "Solution"

        **First**, set up your sandbox using Ubuntu 22.04:

        ```bash 
        apptainer build --sandbox GROMACS.sandbox docker://ubuntu:22.04
        ```

        **Second**, open the sandbox in the apptainer shell

        ```bash
        apptainer shell --writable  --contain --fakeroot GROMACS.sandbox
        ```

        **Third**, type the following commands into the terminal:

        ```bash
        # Update Ubuntu
        apt-get update

        # Set the locate for date
        echo "Pacific/Auckland" > /etc/timezone

        # Install necessary packages
        apt-get install -y \
          build-essential \
          cmake \
          wget \
          python3 \
          libfftw3-dev \
          libgsl-dev \
          ca-certificates

        # Download and install GROMACS 2021.6
        cd /opt
        wget https://ftp.gromacs.org/gromacs/gromacs-2021.6.tar.gz
        tar -xzf gromacs-2021.6.tar.gz
        cd gromacs-2021.6

        # Configure GROMACS 2021.6
        mkdir build
        cd build
        cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gromacs -DGMX_BUILD_OWN_FFTW=OFF -DGMX_MPI=OFF -DGMX_OPENMP=ON -DGMX_GPU=OFF -DGMX_USE_CUDA=OFF

        # Build and install GROMACS 2021.6
        make -j8
        make install

        # Remove unnecessary GROMACS files after installation
        cd /opt
        rm -rfv gromacs-2021.6.tar.gz gromacs-2021.6
        ```

        This will install GROMACS 2021.6 in your container

        **Fourth**, create an environment for GROMACS to run:

        ```bash
        mkdir -p /.singularity.d/env
        rm -rf /.singularity.d/env/90-gromacs.sh
        touch /.singularity.d/env/90-gromacs.sh
        chmod 0755 /.singularity.d/env/90-gromacs.sh
        apt-get install -y nano
        nano /.singularity.d/env/90-gromacs.sh
        ```

        inside `90-gromacs.sh`, add the following:

        ```bash
        # GROMACS environment
        source /opt/gromacs/bin/GMXRC
        ```

        !!! note

            At this point, it is a good idea to see if your container will work by typing in the environment and runscript you gave to the container into the `shell`.

            Try this out by typing into the container's terminal:

            ```bash
            # GROMACS environment
            source /opt/gromacs/bin/GMXRC
            ```

            then:

            ```bash
            gmx --version
            ```

            Hopefully, you should see something happen!

        **Fifth**, we are done modifying our sandbox. We can now get Apptainer to turn our sandbox into a container. Exit out of the container

        ```bash
        Apptainer> exit
        ```

        Then run in the terminal:

        ```bash
        apptainer build GROMACS.sif GROMACS.sandbox
        ```

        This will give you a `sif` container file called `GROMACS.sif` that you can now use. Try it out by typing into the terminal:

        ```bash
        apptainer exec GROMACS.sif gmx --version
        ```

        This should give something like this:

        ```bash
        geoff.weal@login03:~$ apptainer exec GROMACS.sif gmx --version
                                 :-) GROMACS - gmx, 2021.6 (-:

                                    GROMACS is written by:
             Andrey Alekseenko              Emile Apol              Rossen Apostolov     
                 Paul Bauer           Herman J.C. Berendsen           Par Bjelkmar       
               Christian Blau           Viacheslav Bolnykh             Kevin Boyd        
             Aldert van Buuren           Rudi van Drunen             Anton Feenstra      
            Gilles Gouaillardet             Alan Gray               Gerrit Groenhof      
               Anca Hamuraru            Vincent Hindriksen          M. Eric Irrgang      
              Aleksei Iupinov           Christoph Junghans             Joe Jordan        
            Dimitrios Karkoulis            Peter Kasson                Jiri Kraus        
              Carsten Kutzner              Per Larsson              Justin A. Lemkul     
               Viveca Lindahl            Magnus Lundborg             Erik Marklund       
                Pascal Merz             Pieter Meulenhoff            Teemu Murtola       
                Szilard Pall               Sander Pronk              Roland Schulz       
               Michael Shirts            Alexey Shvetsov             Alfons Sijbers      
               Peter Tieleman              Jon Vincent              Teemu Virolainen     
             Christian Wennberg            Maarten Wolf              Artem Zhmurov       
                                   and the project leaders:
                Mark Abraham, Berk Hess, Erik Lindahl, and David van der Spoel

        Copyright (c) 1991-2000, University of Groningen, The Netherlands.
        Copyright (c) 2001-2022, The GROMACS development team at
        Uppsala University, Stockholm University and
        the Royal Institute of Technology, Sweden.
        check out http://www.gromacs.org for more information.

        GROMACS is free software; you can redistribute it and/or modify it
        under the terms of the GNU Lesser General Public License
        as published by the Free Software Foundation; either version 2.1
        of the License, or (at your option) any later version.

        GROMACS:      gmx, version 2021.6
        Executable:   /opt/gromacs/bin/gmx
        Data prefix:  /opt/gromacs
        Working dir:  /nesi/project/nesi99999/geoffreyweal/Tutorials/containers
        Command line:
          gmx --version

        GROMACS version:    2021.6
        Precision:          mixed
        Memory model:       64 bit
        MPI library:        thread_mpi
        OpenMP support:     enabled (GMX_OPENMP_MAX_THREADS = 64)
        GPU support:        disabled
        SIMD instructions:  AVX2_256
        FFT library:        fftw-3.3.8-sse2-avx
        RDTSCP usage:       enabled
        TNG support:        enabled
        Hwloc support:      disabled
        Tracing support:    disabled
        C compiler:         /usr/bin/cc GNU 11.4.0
        C compiler flags:   -mavx2 -mfma -Wno-missing-field-initializers -fexcess-precision=fast -funroll-all-loops -O3 -DNDEBUG
        C++ compiler:       /usr/bin/c++ GNU 11.4.0
        C++ compiler flags: -mavx2 -mfma -Wno-missing-field-initializers -fexcess-precision=fast -funroll-all-loops -fopenmp -O3 -DNDEBUG
        ```

!!! dumbbell "Question 2"

    This student (from question 1) wants to upgrade their version of GROMACS to 2025.4. Make a modification to your sandbox to account for this, and created an updated container using GROMACS 2025.4

    Note: You will want to download GROMACS from `https://ftp.gromacs.org/gromacs/gromacs-2025.4.tar.gz`

    Hint 1: You will need to remove the originally installed GROMACS folder before installing the new GROMACS version:

    ```bash
    rm -rvf /opt/gromacs
    ```

    Hint 2: You can use the same `cmake` and `make` commands as before, but you will need to update `cmake`:

    ```bash
    apt-get purge --auto-remove -y cmake
    apt-get update -y && apt-get install -y software-properties-common lsb-release ca-certificates gpg wget
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null
    apt-get update && apt-get install -y cmake=4.3.1-0kitware1ubuntu22.04.1
    ```


    ??? success "Solution"

        **First**, open the sandbox in the apptainer shell

        ```bash
        apptainer shell --writable  --contain --fakeroot GROMACS.sandbox
        ```

        **Second**, remove the originally installed version of GROMACS

        ```bash
        rm -rvf /opt/gromacs
        ```

        **Third**, update your `cmake`

        ```bash
        apt-get purge --auto-remove -y cmake
        apt-get update -y && apt-get install -y software-properties-common lsb-release ca-certificates gpg wget
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
        echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null
        apt-get update && apt-get install -y cmake=4.3.1-0kitware1ubuntu22.04.1
        ```

        **Fourth**, type the following commands into the terminal:

        ```bash
        # Download and install GROMACS 2021.6
        cd /opt
        wget https://ftp.gromacs.org/gromacs/gromacs-2025.4.tar.gz
        tar -xzf gromacs-2025.4.tar.gz
        cd gromacs-2025.4

        # Configure GROMACS 2025.4
        mkdir build
        cd build
        cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gromacs -DGMX_BUILD_OWN_FFTW=OFF -DGMX_MPI=OFF -DGMX_OPENMP=ON -DGMX_GPU=OFF -DGMX_USE_CUDA=OFF

        # Build and install GROMACS 2025.4
        make -j8
        make install

        # Remove unnecessary GROMACS files after installation
        cd /opt
        rm -rfv gromacs-2025.4.tar.gz gromacs-2025.4
        ```

        This will install GROMACS 2025.4 in your container

        **Fifth**, we still want the environment to point source `/opt/gromacs/bin/GMXRC`, so we dont need to change anything in `/.singularity.d/env`

        !!! note

            At this point, it is a good idea to see if your container will work by typing in the environment and runscript you gave to the container into the `shell`.

            Try this out by typing into the container's terminal:

            ```bash
            # GROMACS environment
            source /opt/gromacs/bin/GMXRC
            ```

            then:

            ```bash
            gmx --version
            ```

            Hopefully, you should see something happen!

        **Sixth**, we are done modifying our sandbox. We can now get Apptainer to turn our sandbox into a container. Exit out of the container

        ```bash
        Apptainer> exit
        ```

        Then run in the terminal:

        ```bash
        apptainer build GROMACS.sif GROMACS.sandbox
        ```

        This will give you a `sif` container file called `GROMACS.sif` that you can now use. Try it out by typing into the terminal:

        ```bash
        apptainer exec GROMACS.sif gmx --version
        ```

        This should give something like this. Notice the version of GROMACS has changed from 2021.6 to 2025.4:

        ```bash
        geoff.weal@login03:/nesi/project/nesi99999/geoffreyweal/Tutorials/containers$ apptainer exec GROMACS.sif gmx --version
                                 :-) GROMACS - gmx, 2025.4 (-:

        Executable:   /opt/gromacs/bin/gmx
        Data prefix:  /opt/gromacs
        Working dir:  /nesi/project/nesi99999/geoffreyweal/Tutorials/containers
        Command line:
          gmx --version

        GROMACS version:     2025.4
        Precision:           mixed
        Memory model:        64 bit
        MPI library:         thread_mpi
        OpenMP support:      enabled (GMX_OPENMP_MAX_THREADS = 128)
        GPU support:         disabled
        SIMD instructions:   AVX2_256
        CPU FFT library:     fftw-3.3.8-sse2-avx
        GPU FFT library:     none
        Multi-GPU FFT:       none
        RDTSCP usage:        enabled
        TNG support:         enabled
        Hwloc support:       disabled
        Tracing support:     disabled
        C compiler:          /usr/bin/cc GNU 11.4.0
        C compiler flags:    -fexcess-precision=fast -funroll-all-loops -mavx2 -mfma -Wno-missing-field-initializers -O3 -DNDEBUG
        C++ compiler:        /usr/bin/c++ GNU 11.4.0
        C++ compiler flags:  -fexcess-precision=fast -funroll-all-loops -mavx2 -mfma -Wno-missing-field-initializers -Wno-cast-function-type-strict SHELL:-fopenmp -O3 -DNDEBUG
        BLAS library:        Internal
        LAPACK library:      Internal
        ```


## Takeaway Points

!!! graduation-cap "What you take away from this lesson"

    - A sandbox is like a container, but you can make changes to it as you go.
    - This makes sandboxes good for debugging.
    - The best way to use sandboxes is for trying things out, then write a `def` file to construct your official container as this container will be easier to `inspect`. 
    - To create a sandbox, use `apptainer build --sandbox`
    - Modify a contaienr by using `apptainer --writable --contain --fakeroot`
