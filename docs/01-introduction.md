# 1. Introduction to Apptainer

!!! clipboard-list "Lesson Objectives"

    - Explain the similarities and differences between a file and a directory.
    - Translate an absolute path into a relative path and vice versa.
    - Construct absolute and relative paths that identify specific files and directories.
    - Use options and arguments to change the behaviour of a shell command.
    - Demonstrate the use of tab completion and explain its advantages.


!!! clipboard-question "Questions"

    - How can I move around on my computer?
    - How can I see what files and directories I have?
    - How can I specify the location of a file or directory on my computer?


Apptainer is loaded on mahuika by default. If you type in `apptainer --version` into the terminal:

```bash
geoff.weal@codeserver-nesi99992-d23vsxxe:~$ apptainer --version
apptainer version 1.4.2-1.el9
```

You will see the version of Apptainer available to you on Mahuika. 

If you type in `apptainer --help` into the terminal, you will see all the options available to you:

```bash
geoff.weal@codeserver-nesi99992-d23vsxxe:~$ apptainer --help

Linux container platform optimized for High Performance Computing (HPC) and
Enterprise Performance Computing (EPC)

Usage:
  apptainer [global options...]

Description:
  Apptainer containers provide an application virtualization layer enabling
  mobility of compute via both application and environment portability. With
  Apptainer one is capable of building a root file system that runs on any
  other Linux system where Apptainer is installed.

Options:
      --build-config    use configuration needed for building containers
  -c, --config string   specify a configuration file (for root or
                        unprivileged installation only) (default
                        "/etc/apptainer/apptainer.conf")
  -d, --debug           print debugging information (highest verbosity)
  -h, --help            help for apptainer
      --nocolor         print without color output (default False)
  -q, --quiet           suppress normal output
  -s, --silent          only print errors
  -v, --verbose         print additional information
      --version         version for apptainer

Available Commands:
  build       Build an Apptainer image
  cache       Manage the local cache
  capability  Manage Linux capabilities for users and groups
  checkpoint  Manage container checkpoint state (experimental)
  completion  Generate the autocompletion script for the specified shell
  config      Manage various apptainer configuration (root user only)
  delete      Deletes requested image from the library
  exec        Run a command within a container
  help        Help about any command
  inspect     Show metadata for an image
  instance    Manage containers running as services
  key         Manage OpenPGP keys
  keyserver   Manage apptainer keyservers
  oci         Manage OCI containers
  overlay     Manage an EXT3 writable overlay image
  plugin      Manage Apptainer plugins
  pull        Pull an image from a URI
  push        Upload image to the provided URI
  registry    Manage authentication to OCI/Docker registries
  remote      Manage apptainer remote endpoints
  run         Run the user-defined default command within a container
  run-help    Show the user-defined help for an image
  search      Search a Container Library for images
  shell       Run a shell within a container
  sif         Manipulate Singularity Image Format (SIF) images
  sign        Add digital signature(s) to an image
  test        Run the user-defined tests within a container
  verify      Verify digital signature(s) within an image
  version     Show the version for Apptainer

Examples:
  $ apptainer help <command> [<subcommand>]
  $ apptainer help build
  $ apptainer help instance start
```

We will be looking at a few of these, in particular:

* `build`
* `cache`
* `exec`
* `inspect`
* `pull`
* `run`
* `run-help`
* `shell`
* `verify`




!!! graduation-cap "Keypoints"

- Use `apptainer --help` to list all the options available in Apptainer
