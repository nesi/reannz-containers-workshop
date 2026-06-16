# S3: Running Containers as Instances

!!! clipboard-list "Lesson Objectives"

    - Understand what an instance is and when you would use one.
    - Learn how to start, list, connect to, and stop an instance.
    - Know how the `%startscript` section controls what an instance runs.

!!! clipboard-question "Questions"

    - How do I run a container in the background as a long-running service?
    - How do I connect to a container that is already running?

So far we have run containers in the foreground — we type `apptainer run`, `exec`, or `shell`, the container does its job, and we get our terminal back when it finishes. Sometimes, though, you want a container to keep running in the **background** as a service — for example a web server, a database, or any program that other processes connect to while it runs. Apptainer lets you do this using **instances**.

## What is an instance?

An *instance* is a running copy of a container that Apptainer keeps alive in the background. Instead of running the container and waiting for it to finish, you **start** the instance, give it a name, and carry on using your terminal. The instance keeps running until you **stop** it, and you can connect to it whenever you like using its name.

This is useful when:

* you want to run a service (a web server, a database, etc.) that stays up while you do other work,
* several programs need to talk to the same running container, or
* you want to start something once and connect to it again and again without restarting it.

## The `%startscript` section

When you `run` a container, Apptainer executes its `%runscript`. When you *start an instance*, Apptainer instead executes its **`%startscript`**. This is the section of the `def` file that defines the long-running process the instance should keep alive in the background.

For example, here is a `def` file for a simple web server that serves files over HTTP using Python:

```def
Bootstrap: docker
From: ubuntu:24.04

%labels
    Author Your Name
    Version 1.0.0
    Description "A simple background web server, run as an instance"

%post
    apt-get -y update
    apt-get -y install python3

%startscript
    cd /srv
    exec python3 -m http.server 8080
```

The `%startscript` is what runs when the instance is started — here it launches a Python web server listening on port `8080`. We build the container in the usual way:

```bash
apptainer build webserver.sif webserver.def
```

## Starting an instance

You start an instance with `apptainer instance start`, giving it the container and a name of your choice:

```bash
apptainer instance start <container>.sif <instance-name>
```

For our web server, we will name the instance `web1`:

```bash
user.name@computer-name:~$ apptainer instance start webserver.sif web1
INFO:    instance started successfully
```

Notice that you get your terminal back immediately — the web server is now running in the background, executing the `%startscript`.

## Listing running instances

You can see all the instances you currently have running with `apptainer instance list`:

```bash
user.name@computer-name:~$ apptainer instance list
INSTANCE NAME    PID        IP    IMAGE
web1             214567           /home/user.name/webserver.sif
```

This shows each instance's name, its process ID (`PID`), and the image it was started from.

## Connecting to a running instance

To run a command inside a running instance, use `exec` (or `shell`) with the special `instance://` prefix followed by the instance name:

```bash
apptainer exec instance://<instance-name> <command>
```

For example, to check that our web server is responding, we can run a command inside the instance:

```bash
user.name@computer-name:~$ apptainer exec instance://web1 curl -s http://localhost:8080
```

Or to work inside the running instance interactively:

```bash
apptainer shell instance://web1
```

The key difference from a normal `apptainer exec webserver.sif ...` is that `instance://web1` connects to the **already-running** container, rather than starting a fresh one.

## Stopping an instance

When you are finished, stop the instance with `apptainer instance stop`:

```bash
user.name@computer-name:~$ apptainer instance stop web1
INFO:    Stopping web1 instance of /home/user.name/webserver.sif (PID=214567)
```

You can stop every running instance at once with:

```bash
apptainer instance stop --all
```

!!! note

    Instances run only on the machine where you started them. On an HPC like Mahuika, an instance you start on a login node is not visible from a compute node, and vice versa. If you want a service to run alongside a batch job, start the instance from within your slurm script.

## Exercises

!!! dumbbell "Question 1"

    What is the difference between `apptainer run webserver.sif` and `apptainer instance start webserver.sif web1`? Which section of the `def` file does each one execute?

    ??? success "Solution"

        `apptainer run webserver.sif` runs the container in the **foreground** and executes its **`%runscript`** — your terminal is tied up until the container finishes.

        `apptainer instance start webserver.sif web1` starts the container in the **background** as a named instance (`web1`) and executes its **`%startscript`** — you get your terminal back immediately, and the instance keeps running until you stop it.

!!! dumbbell "Question 2"

    You have started an instance called `web1`. How would you (a) check it is running, (b) run the command `ps aux` inside it, and (c\) stop it?

    ??? success "Solution"

        **(a)** List your running instances:

        ```bash
        apptainer instance list
        ```

        **(b)** Run a command inside the running instance using the `instance://` prefix:

        ```bash
        apptainer exec instance://web1 ps aux
        ```

        **(c\)** Stop the instance:

        ```bash
        apptainer instance stop web1
        ```

!!! dumbbell "Question 3"

    You want to write a container that runs a background service. Which section of the `def` file should the service command go in, and why?

    ??? success "Solution"

        The service command should go in the **`%startscript`** section. When you start an instance with `apptainer instance start`, Apptainer executes the `%startscript` (not the `%runscript`), so this is where you put the long-running process you want the instance to keep alive in the background.

!!! graduation-cap "Keypoints"

    - An instance is a running copy of a container that Apptainer keeps alive in the **background**.
    - Use instances when you want a long-running service, or when several programs need to connect to the same running container.
    - Start an instance with `apptainer instance start <container>.sif <name>`, and it runs the container's `%startscript`.
    - List running instances with `apptainer instance list`.
    - Connect to a running instance with `apptainer exec instance://<name> <command>` or `apptainer shell instance://<name>`.
    - Stop an instance with `apptainer instance stop <name>` (or `--all` to stop them all).
    - Instances run only on the machine where you started them.
