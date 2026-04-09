# 1. First steps - Say Goodbye to the 🐭  ( mostly)

!!! clipboard-list "Lesson Objectives"

    - Navigate your file system using the command line.
    - Access and read help files for `bash` programs and use help files to identify useful command options.
    - Demonstrate the use of tab completion, and explain its advantages.


!!! clipboard-question "questions"

    - What is a command shell and why would I use one?
    - How can I move around on my computer?
    - How can I see what files and directories I have?
    - How can I specify the location of a file or directory on my computer?


## How to access the shell 

On a Mac or Linux machine, you can access a shell through a program called "Terminal", which is already available
on your computer. The Terminal is a window into which we will type commands. If you're using Windows,
you'll need to download a separate program to access the shell.

To save time, we are going to be working on a remote server where all the necessary data and software available.
When we say a 'remote server', we are talking about a computer that is not the one you are working on right now.



## Navigating your file system

The part of the operating system that manages files and directories
is called the **file system**.
It organises our data into files,
which hold information,
and directories (also called "folders"),
which hold files or other directories.

Several commands are frequently used to create, inspect, rename, and delete files and directories.

!!! terminal "code"

    ```bash
    $
    ```

The dollar sign is a **prompt**, which shows us that the shell is waiting for input;
your shell may use a different character as a prompt and may add information before
the prompt. When typing commands, either from these lessons or from other sources,
do not type the prompt, only the commands that follow it.

Let's find out where we are by running a command called `pwd`
(which stands for "print working directory").
At any moment, our **current working directory**
is our current default directory,
i.e.,
the directory that the computer assumes we want to run commands in,
unless we explicitly specify something else.
Here,
the computer's response is `/home/<username>`,
which is the top level directory within REANNZ:

!!! terminal "code"
    ```bash
    $ pwd
    ```

    ```output
    /home/<username>
    ```

Let's look at how our file system is organised. We can see what files and subdirectories are in this directory by running `ls`,
which stands for "listing":

!!! terminal "code"

    ```bash
    $ ls
    ```

    ```output
    shell_data
    ```

`ls` prints the names of the files and directories in the current directory in
alphabetical order,
arranged neatly into columns.
We'll be working within the `shell_data` subdirectory, and creating new subdirectories, throughout this workshop.

The command to change locations in our file system is `cd`, followed by a
directory name to change our working directory.
`cd` stands for "change directory".

Let's say we want to navigate to the `shell_data` directory we saw above. We can
use the following command to get there:


!!! terminal "code"

    ```bash
    cd shell_data
    ```

    and take a look

    ```bash
    $ ls
    ```

    ```output
    sra_metadata  untrimmed_fastq
    ```

We can make the `ls` output more comprehensible by using the **flag** `-F`,
which tells `ls` to add a trailing `/` to the names of directories:

!!! terminal "code"

    ```bash
    $ ls -F
    ```

    ```output
    sra_metadata/  untrimmed_fastq/
    ```

!!! circle-info "what is `/`"

    Anything with a `/` after it is a directory. Things with a "\*" after them are programs. If
    there are no decorations, it's a file.


!!! circle-info "`ls` has lots of other options. To find out what they are, we can type:"

    ```bash
    $ man ls
    ```

    `man` (short for manual) displays detailed documentation (also referred as man page or man file)
    for `bash` commands. It is a powerful resource to explore `bash` commands, understand
    their usage and flags. Some manual files are very long. You can scroll through the
    file using your keyboard's down arrow or use the <kbd>Space</kbd> key to go forward one page
    and the <kbd>b</kbd> key to go backwards one page. When you are done reading, hit <kbd>q</kbd>
    to quit.


!!! magnifying-glass "Busy looking terminal ? time to 🆑"
    
    Type the word `clear` into the terminal and press the `Enter` key.

    !!! terminal "code"

        ```bash
        $ clear
        ```

    This will scroll your screen down to give you a fresh screen and will make it easier to read.
    You haven't lost any of the information on your screen. If you scroll up, you can see everything that has been output to your screen
    up until this point.



    !!! tip "Hot-key combinations are shortcuts for performing common commands."

        The hot-key combination for clearing the console is `Ctrl+L`. Feel free to try it and see for yourself.


!!! question "Challenge"

    Use the `-l` option for the `ls` command to display more information for each item
    in the directory. What is one piece of additional information this long format
    gives you that you don't see with the bare `ls` command?

    ??? check-to-slot "solution"

        ```bash
        $ ls -l
        ```

        ```output
        total 8
        drwxr-x--- 2 training training 4096 Jul 30  2015 sra_metadata
        drwxr-xr-x 2 training training 4096 Nov 15  2017 untrimmed_fastq
        ```

        The additional information given includes the name of the owner of the file,
        when the file was last modified, and whether the current user has permission
        to read and write to the file.

No one can possibly learn all of these arguments, that's what the manual page
is for. You can (and should) refer to the manual page or other help files
as needed.

Let's go into the `untrimmed_fastq` directory and see what is in there.

!!! terminal "code"

    ```bash
    $ cd untrimmed_fastq
    $ ls -F
    ```

    ```output
    SRR097977.fastq  SRR098026.fastq
    ```

This directory contains two files with `.fastq` extensions. FASTQ is a format
for storing information about sequencing reads and their quality.
We will be learning more about FASTQ files in a later lesson.

### Shortcut: Tab Completion

Typing out file or directory names can waste a
lot of time and it's easy to make typing mistakes. Instead we can use tab complete
as a shortcut. When you start typing out the name of a directory or file, then
hit the <kbd>Tab</kbd> key, the shell will try to fill in the rest of the
directory or file name.

Return to your home directory:

!!! terminal "code"
    ```bash
    $ cd
    ```

    then enter:

    ```bash
    $ cd she<tab>
    ```

The shell will fill in the rest of the directory name for `shell_data`.

Now change directories to `untrimmed_fastq` in `shell_data`

!!! terminal "code"

    ```bash
    $ cd shell_data
    $ cd untrimmed_fastq
    ```

Using tab complete can be very helpful. However, it will only autocomplete
a file or directory name if you've typed enough characters to provide
a unique identifier for the file or directory you are trying to access.

For example, if we now try to list the files which names start with `SR`
by using tab complete:

!!! terminal "code"

    ```bash
    $ ls SR<tab>
    ```

The shell auto-completes your command to `SRR09`, because all file names in
the directory begin with this prefix. When you hit
<kbd>Tab</kbd> again, the shell will list the possible choices.

!!! terminal "code"

    ```bash
    $ ls SRR09<tab><tab>
    ```

    ```output
    SRR097977.fastq  SRR098026.fastq
    ```

Tab completion can also fill in the names of programs, which can be useful if you
remember the beginning of a program name.

!!! terminal "code"

    ```bash
    $ pw<tab><tab>
    ```

    ```output
    pwck      pwconv    pwd       pwdx      pwunconv
    ```

Displays the name of every program that starts with `pw`.

!!! graduation-cap "Summary"

    We now know how to move around our file system using the command line.
    This gives us an advantage over interacting with the file system through
    a GUI as it allows us to work on a remote server, carry out the same set of operations
    on a large number of files quickly, and opens up many opportunities for using
    bioinformatic software that is only available in command line versions.
    
    In the next few episodes, we'll be expanding on these skills and seeing how
    using the command line shell enables us to make our workflow more efficient and reproducible.
         
    - The shell gives you the ability to work more efficiently by using keyboard commands rather than a GUI.
    - Useful commands for navigating your file system include: `ls`, `pwd`, and `cd`.
    - Most commands take options (flags) which begin with a `-`.
    - Tab completion can reduce errors from mistyping and make work more efficient in the shell.
