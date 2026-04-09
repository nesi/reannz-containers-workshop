# 2. Navigating Files and Directories

!!! clipboard-list "Lesson objectives"

    - Use a single command to navigate multiple steps in your directory structure, including moving backwards (one level up).
    - Perform operations on files in directories outside your working directory.
    - Work with hidden directories and hidden files.
    - Interconvert between absolute and relative paths.
    - Employ navigational shortcuts to move around your file system.

!!! clipboard-question "questions"

    - How can I perform operations on files outside of my working directory?
    - What are some navigational shortcuts I can use to make my work more efficient?
    


## Moving around the file system

We've learned how to use `pwd` to find our current location within our file system.
We've also learned how to use `cd` to change locations and `ls` to list the contents
of a directory. Now we're going to learn some additional commands for moving around
within our file system.

Use the commands we've learned so far to navigate to the `shell_data/untrimmed_fastq` directory, if
you're not already there.

!!! terminal "code"

    ```bash
    $ cd
    $ cd ~/shell_data
    $ cd untrimmed_fastq
    ```

!!! terminal-2 "What if we want to move back up and out of this directory and to our top level directory? Can we type `cd shell_data`? Try it and see what happens."

    ```bash
    $ cd shell_data
    ```
    
    ```output
    -bash: cd: shell_data: No such file or directory
    ```

Your computer looked for a directory or file called `shell_data` within the
directory you were already in. It didn't know you wanted to look at a directory level
above the one you were located in.

!!! terminal-2 "We have a special command to tell the computer to move us back or up one directory level."

    ```bash
    $ cd ..
    ```

Now we can use `pwd` to make sure that we are in the directory we intended to navigate
to, and `ls` to check that the contents of the directory are correct.

!!! terminal "code"

    ```bash
    $ pwd
    ```

    ```output
    /home/<username>//shell_data
    ```

    ```bash
    $ ls
    ```

    ```output
    sra_metadata  untrimmed_fastq
    ```

From this output, we can see that `..` did indeed take us back one level in our file system.

!!! terminal-2 "You can chain these together like so:"

    ```bash
    $ ls ../../
    ```

prints the contents of `/home/<username>/shell_data`.

## Finding hidden directories

!!! question "Let's find a hidden directory and list it's content"
    First navigate to the `shell_data` directory. There is a hidden directory within this directory. Explore the options for `ls` to
    find out how to see hidden directories. List the contents of the directory and identify the name of the text file in that directory.

    Hint: hidden files and folders in Unix start with `.`, for example `.my_hidden_directory`


    ??? check-to-slot "Solution"

        First use the `man` command to look at the options for `ls`.

        ```bash
        $ man ls
        ```

        The `-a` option is short for `all` and says that it causes `ls` to "not ignore
        entries starting with ." This is the option we want.

        ```bash
        $ ls -a
        ```

        ```output
        .  ..  .hidden	sra_metadata  untrimmed_fastq
        ```

        The name of the hidden directory is `.hidden`. We can navigate to that directory
        using `cd`.

        ```bash
        $ cd .hidden
        ```

        And then list the contents of the directory using `ls`.

        ```bash
        $ ls
        ```

        ```output
        youfoundit.txt
        ```

        The name of the text file is `youfoundit.txt`.

In most commands the flags can be combined together in no particular order to obtain the desired results/output.

!!! terminal "code"

    ```
    $ ls -Fa
    $ ls -laF
    ```

## Examining the contents of other directories

By default, the `ls` commands lists the contents of the working
directory (i.e. the directory you are in). You can always find the
directory you are in using the `pwd` command. However, you can also
give `ls` the names of other directories to view. Navigate to your
home directory if you are not already there.

!!! terminal "code"

    ```bash
    $ cd
    ```

    Then enter the command:

    ```bash
    $ ls ~/shell_data
    ```

    ```output
    sra_metadata  untrimmed_fastq
    ```

This will list the contents of the `shell_data` directory without
you needing to navigate there.

The `cd` command works in a similar way.

!!! terminal-2 "Try entering:"

    ```bash
    $ cd
    $ cd ~/shell_data/untrimmed_fastq
    ```

    This will take you to the `untrimmed_fastq` directory without having to go through
    the intermediate directory.

!!! dumbbell "Navigating practice"

    Navigate to your home directory. From there, list the contents of the `untrimmed_fastq`
    directory.

    ??? success "Solution"

        ```bash
        $ cd
        $ ls ~/shell_data/untrimmed_fastq/
        ```

        ```output
        SRR097977.fastq  SRR098026.fastq
        ```

## Full vs. Relative Paths

The `cd` command takes an argument which is a directory
name. Directories can be specified using either a _relative_ path or a
full _absolute_ path. The directories on the computer are arranged into a
hierarchy. The full path tells you where a directory is in that
hierarchy. Navigate to the home directory, then enter the `pwd`
command.

!!! terminal "code"

    ```bash
    $ cd
    $ pwd
    ```

    You will see:

    ```output
    /home/<username>
    ```

This is the full name of your home directory. This tells you that you
are in a directory called `training`, which sits inside a directory called
`home` which sits inside the very top directory in the hierarchy. The
very top of the hierarchy is a directory called `/` which is usually
referred to as the _root directory_. So, to summarise: `training` is a
directory in `home` which is a directory in `/`. More on `root` and
`home` in the next section.

!!! terminal-2 "Now enter the following command:"

    ```bash
    $ cd /home/<username>/shell_data/.hidden
    ```

    This jumps forward multiple levels to the `.hidden` directory.
    Now go back to the home directory.

    ```bash
    $ cd
    ```

You can also navigate to the `.hidden` directory using:

!!! terminal "code"

    ```bash
    $ cd ~/shell_data/.hidden
    ```

These two commands have the same effect, they both take us to the `.hidden` directory.
The first uses the absolute path, giving the full address from the home directory. The
second uses a relative path, giving only the address from the working directory. A full
path always starts with a `/`. A relative path does not.

A relative path is like getting directions from someone on the street. They tell you to
"go right at the stop sign, and then turn left on Main Street". That works great if
you're standing there together, but not so well if you're trying to tell someone how to
get there from another country. A full path is like GPS coordinates. It tells you exactly
where something is no matter where you are right now.

You can usually use either a full path or a relative path depending on what is most convenient.
If we are in the home directory, it is more convenient to enter the full path.
If we are in the working directory, it is more convenient to enter the relative path
since it involves less typing.

Over time, it will become easier for you to keep a mental note of the
structure of the directories that you are using and how to quickly
navigate amongst them.



## Relative path resolution

!!! dumbbell "Using the filesystem diagram below, if `pwd` displays `/Users/thing`," what will `ls ../backup` display?"

    1. `../backup: No such file or directory`
    2. `2012-12-01 2013-01-08 2013-01-27`
    3. `2012-12-01/ 2013-01-08/ 2013-01-27/`
    4. `original pnas_final pnas_sub`

    ![](fig/filesystem-challenge.svg){alt='File System for Challenge Questions'}


    ??? success "Solution"

        1. No: there _is_ a directory `backup` in `/Users`.
        2. No: this is the content of `Users/thing/backup`,
           but with `..` we asked for one level further up.
        3. No: see previous explanation.
           Also, we did not specify `-F` to display `/` at the end of the directory names.
        4. Yes: `../backup` refers to `/Users/backup`.


### Navigational Shortcuts

The root directory is the highest level directory in your file
system and contains files that are important for your computer
to perform its daily work. While you will be using the root (`/`)
at the beginning of your absolute paths, it is important that you
avoid working with data in these higher-level directories, as
your commands can permanently alter files that the operating
system needs to function. In many cases, trying to run commands
in `root` directories will require special permissions which are
not discussed here, so it's best to avoid them and work within your
home directory. Dealing with the `home` directory is very common.
The tilde character, `~`, is a shortcut for your home directory.
In our case, the `root` directory is **two** levels above our
`home` directory, so `cd` or `cd ~` will take you to
`/home/<username>` and `cd /` will take you to `/`. Navigate to the
`shell_data` directory:

!!! terminal "code"

    ```bash
    $ cd
    $ cd ~/shell_data
    ```

    Then enter the command:

    ```bash
    $ ls ~
    ```

    ```output
    shell_data
    ```

This prints the contents of your home directory, without you needing to
type the full path.

!!! quote ""

    The commands `cd`, and `cd ~` are very useful for quickly navigating back to your home directory. We will be using the `~` character in later lessons to specify our home directory.


??? dumbbell "Additional Challenge 1: Get to home"

    Starting from `/Users/nelle/data`, which of the following commands could Nelle use to navigate to their home directory, which is `/Users/nelle`?

    1. `cd .`
    2. `cd /`
    3. `cd /home/nelle`
    4. `cd ../..`
    5. `cd ~`
    6. `cd home`
    7. `cd ~/data/..`
    8. `cd`
    9. `cd ..`
    
    ??? success "Solution"

        1. No: `.` stands for the current directory.
        2. No: `/` stands for the root directory.
        3. No: Nelle’s home directory is `/Users/nelle`.
        4. No: this command goes up two levels, i.e. ends in `/Users`.
        5. Yes: `~` stands for the user’s home directory, in this case `/Users/nelle`.
        6. No: this command would navigate into a directory home in the current directory if it exists.
        7. Yes: unnecessarily complicated, but correct.
        8. Yes: shortcut to go back to the user’s home directory.
        9. Yes: goes up one level.

??? dumbbell "Additional Challenge 2: `ls` reading comprehension"
    
    Using the filesystem diagram below, if `pwd` displays `/Users/backup`, and `-r` tells `ls` to display things in reverse order, what command(s) will result in the following output:

    ```bash
    pnas_sub/ pnas_final/ original/
    ```

    ![](fig/filesystem-challenge.svg){alt='File System for Challenge Questions'}

    1. `ls pwd`
    2. `ls -r -F`
    3. `ls -r -F /Users/backup`

    ??? success "Solution"
        
        1. No: `pwd` is not the name of a directory.
        2. Yes: `ls` without directory argument lists files and directories in the current directory.
        3. Yes: uses the absolute path explicitly.





    

!!! graduation-cap "Summary"

    - The `/`, `~`, and `..` characters represent important navigational shortcuts.
    - Hidden files and directories start with `.` and can be viewed using `ls -a`.
    - Relative paths specify a location starting from the current location, while absolute paths specify a location from the root of the file system.


