# S1: Other Options for Building Containers

!!! clipboard-list "Lesson Objectives"

    - See the full set of sections that a `def` file can contain, beyond the basics covered in [Chapter 4](04-building-images.md).
    - Understand what the `%arguments`, `%setup`, `%files`, `%startscript`, and `%help` sections are for.
    - Know that a `def` file can be parameterised with build-time arguments and split into multiple build stages.

!!! clipboard-question "Questions"

    - What other sections can I include in a `def` file, and what does each one do?
    - How can I make a `def` file configurable when I build it?

In [Chapter 4](04-building-images.md) we built a container using the most common `def` file sections: `Bootstrap`, `From`, `%labels`, `%environment`, `%post`, and `%runscript`. These are all you need for most containers. However, a `def` file can contain several other sections, and this supplementary page describes the full set so you know what is available.

## The Sections of a `def` File

A `def` file can contain the sections below. You only need to include the ones relevant to your container — most containers use just a handful.

The header keywords sit at the very top of the file:

* `Bootstrap` and `From`: the base image the container is built on (see [Chapter 4](04-building-images.md)).
* `Stage`: names a build stage. This is used for *multi-stage builds*, where you build software in one stage and copy only the finished result into a smaller final stage (see [Multi-Stage Builds](#multi-stage-builds) below).

The remaining sections each begin with a `%` keyword:

* `%arguments`: defines default values for *template variables* — the `{{ ... }}` placeholders used elsewhere in the file. For example, `{{ VERSION }}` is filled in from the `VERSION` value set in `%arguments`. You can override these at build time with the `--build-arg` option.
* `%setup`: commands that run on the **host** during the build, *before* `%post`. The container's file system is available through the `$APPTAINER_ROOTFS` variable, so you can create or place files into the container from the host. (Use this with care — these commands run on your own machine, not inside the container.)
* `%files`: copies files from the host into the container, written as `source destination` (we used this in [Chapter 8](08-running-MPI-containers.md) to copy programs into MPI containers).
* `%environment`: environment variables that are set every time the container *runs* (see [Chapter 4](04-building-images.md)). Note that these are not available during `%post` — they apply at runtime, not at build time.
* `%post`: commands run **inside** the container during the build to install and configure software (see [Chapter 4](04-building-images.md)).
* `%runscript`: the commands run when you `apptainer run` the container (see [Chapter 4](04-building-images.md)).
* `%startscript`: the commands run when you start the container as a background service with `apptainer instance start`.
* `%test`: commands run at the end of the build (and whenever you run `apptainer test`) to check that the container was built correctly (see [Chapter 6](06-testing-containers.md)).
* `%labels`: metadata such as the author and version, which you can read back with `apptainer inspect` (see [Chapter 4](04-building-images.md) and [Chapter 5](05-editing-containers.md)).
* `%help`: free text describing the container, shown when a user runs `apptainer run-help` (see [S2: Other Commands in Apptainer](S2-other-commands-in-apptainer.md)).

## A Note on `%setup` vs `%post`

Two of these sections sound similar but are very different, and it is worth being clear on the distinction:

* `%post` runs **inside** the container — this is where you install software.
* `%setup` runs **on the host** — it can reach into the container's file system via `$APPTAINER_ROOTFS`, but the commands themselves execute on your machine.

Most of the time you want `%post`. Only use `%setup` when you specifically need to prepare files on the host before they go into the container.

## Multi-Stage Builds

The `Stage` keyword lets you split a build into multiple stages. A common pattern is to compile software in a "build" stage (which needs compilers and development tools) and then copy only the finished program into a clean final stage. This keeps the final container small, because the compilers and intermediate build files are left behind. You refer to files from an earlier stage using `%files from <stage-name>`.

## A Complete Example

The `def` file below uses *every* section, so you can see them all in one place:

```def
Bootstrap: docker
From: ubuntu:{{ VERSION }}
Stage: build

%arguments
    VERSION=24.04

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

Note that this is a very complete `def` file, which makes it look overwhelming. In general you do not need to include all these features — most containers use only `Bootstrap`, `From`, `%post`, and `%runscript`. We show it here just to illustrate everything a `def` file *can* contain.


!!! graduation-cap "Keypoints"

    - A `def` file supports many sections; include only the ones your container needs.
    - `%setup` runs on the host (with the container available at `$APPTAINER_ROOTFS`), while `%post` runs inside the container.
    - `%files` copies files in, `%startscript` defines a background service, `%test` validates the build, and `%help` provides documentation via `apptainer run-help`.
    - `%arguments` and `{{ ... }}` templating let you parameterise a build, and the `Stage` keyword enables multi-stage builds that keep the final container small.
