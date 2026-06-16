# 6. Making Tests in Containers

!!! clipboard-list "Lesson Objectives"

    - Understand why you should test a container.
    - Learn how to add a `%test` section to your `def` file.
    - Learn how to run a container's tests with `apptainer test`.
    - Understand how tests are run automatically when a container is built.

!!! clipboard-question "Questions"

    - How do I check that a container actually works as intended?
    - How can the person who builds a container give users a way to verify it?

When you share a container — with collaborators, or by running it on an HPC like Mahuika — you want some confidence that it actually works before you rely on it. A container that builds successfully will not always *run* correctly: a package might be missing, a binary might not be on the `PATH`, or a library might fail to load.

Apptainer lets the **creator** of a container embed a set of self-tests inside it. Any **user** can then run those tests with a single command to confirm the container behaves as expected, without needing to know how it was built.

## The `%test` section

You add tests to a container by including a `%test` section in your `def` file. The commands in this section are run *inside* the container, and the test **passes if the section exits with status `0`** and **fails if it exits with a non-zero status**.

For example, consider a container built to run the `fortune`, `cowsay`, and `lolcat` tools. We can add a `%test` section that checks each of these programs is present (the full file is available as [`lolcow.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/06_making_tests_in_containers/lolcow.def)):

```def
Bootstrap: docker
From: ubuntu:24.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    fortune | cowsay | lolcat

%test
    echo "Running container self-tests..."

    # Helper: check a command exists, fail the test if it does not
    check_found () {
        if command -v "$1" >/dev/null 2>&1; then
            echo "$1 was found"
        else
            echo "ERROR: $1 was NOT found"
            exit 1
        fi
    }

    check_found fortune
    check_found cowsay
    check_found lolcat
```

The key detail is the `exit 1` — if any program is missing, the test section exits with a non-zero status and Apptainer reports the test as **failed**.

## Running the tests with `apptainer test`

Once the container is built (here, `lolcow.sif`), anyone can run its tests with:

```bash
apptainer test lolcow.sif
```

If everything is in order you will see:

```bash
user.name@computer-name:~$ apptainer test lolcow.sif
Running container self-tests...
fortune was found
cowsay was found
lolcat was found
```

If a test fails, the failing message is printed and the command returns a non-zero exit code, which makes it easy to use in scripts:

```bash
user.name@computer-name:~$ apptainer test lolcow.sif
Running container self-tests...
ERROR: lolcat was NOT found
```

## Tests run automatically at build time

By default, Apptainer runs the `%test` section automatically **at the end of a build**, so a broken container is caught immediately:

```bash
apptainer build lolcow.sif lolcow.def
```

You will see the test output appear once the build has finished. If you want to skip the tests during the build (for example, while you are still developing the `def` file), use the `--notest` flag:

```bash
apptainer build --notest lolcow.sif lolcow.def
```

## Writing good tests

A useful `%test` section does more than check that files exist — it confirms the container does what it is meant to do. Some good things to test:

- **Programs are installed and on the `PATH`** (as in the example above).
- **A program actually runs** and produces the expected output, e.g. `python3 -c "import numpy; print(numpy.__version__)"`.
- **The correct *version* is installed**, which is important for reproducibility.
- **Key data files or directories exist** inside the container.

!!! tip

    Keep your tests fast and self-contained. The aim is a quick "does this container work?" check that a user can run before launching a long job on the HPC — not a full test suite.

## Exercises

For these exercises, we will use the [`my_python3.12.def`](https://github.com/nesi/reannz-containers-workshop/blob/main/examples/06_making_tests_in_containers/my_python3.12.def) file from Chapter 4, which builds a container with Python 3.12.

!!! dumbbell "Question 1"

    Add a `%test` section to the `my_python3.12.def` file that checks `python3.12` is installed and available on the `PATH`.

    ??? success "Solution"

        Add the following `%test` section to the `def` file:

        ```def
        %test
            echo "Running container self-tests..."

            if command -v python3.12 >/dev/null 2>&1; then
                echo "python3.12 was found"
            else
                echo "ERROR: python3.12 was NOT found"
                exit 1
            fi
        ```

!!! dumbbell "Question 2"

    You have just built the container as `my_python3.12.sif`. How would you run its tests? And how could you build a container *without* running its tests?

    ??? success "Solution"

        Run the tests on the built container with:

        ```bash
        apptainer test my_python3.12.sif
        ```

        The tests also run automatically at the end of `apptainer build my_python3.12.sif my_python3.12.def`. To build *without* running the tests, use the `--notest` flag:

        ```bash
        apptainer build --notest my_python3.12.sif my_python3.12.def
        ```

!!! dumbbell "Question 3"

    Checking that `python3.12` exists is good, but for reproducibility we often want to confirm the *correct version* is installed. Write a `%test` section that fails unless the container's Python is version `3.12`.

    ??? success "Solution"

        We can run `python3.12 --version` and check its output contains `3.12`:

        ```def
        %test
            echo "Running container self-tests..."

            if python3.12 --version | grep -q "3.12"; then
                echo "Python 3.12 was found"
            else
                echo "ERROR: Python 3.12 was NOT found"
                exit 1
            fi
        ```

        Because the test exits with a non-zero status (`exit 1`) when the version does not match, `apptainer test` (and the build) will report it as failed.


!!! graduation-cap "Keypoints"

    - Use the `%test` section of a `def` file to embed self-tests in a container.
    - The test **passes on exit code `0`** and **fails on any non-zero exit code** — use `exit 1` to flag problems.
    - Run a container's tests with `apptainer test <container>.sif`.
    - Tests run automatically at the end of a build; skip them with `apptainer build --notest`.
