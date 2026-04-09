# 3. Working with Files and Directories


!!! clipboard-list "Lesson objectives"

    - View, search within, copy, move, and rename files. Create new directories.
    - Use wildcards (`*`) to perform operations on multiple files.
    - Make a file read only.
    - Use the `history` command to view and repeat recently used commands.

!!! clipboard-question "questions"

    - How can I view and search file contents?
    - How can I create, copy and delete files and directories?
    - How can I control who has permission to modify a file?
    - How can I repeat recently used commands?



## Working with Files

### Our data set: FASTQ files

Now that we know how to navigate around our directory structure, let's
start working with our sequencing files. We did a sequencing experiment and
have two results files, which are stored in our `untrimmed_fastq` directory.

### Wildcards

!!! terminal-2 "Navigate to your `untrimmed_fastq` directory:"

    ```bash
    $ cd ~/shell_data/untrimmed_fastq
    ```

    We are interested in looking at the FASTQ files in this directory. We can list
    all files with the .fastq extension using the command:

    ```bash
    $ ls *.fastq
    ```

    ```output
    SRR097977.fastq  SRR098026.fastq
    ```

The `*` character is a special type of character called a wildcard, which can be used to represent any number of any type of character.
Thus, `*.fastq` matches every file that ends with `.fastq`.

This command:

!!! terminal "code"

    ```bash
    $ ls *977.fastq
    ```

    ```output
    SRR097977.fastq
    ```
 
    lists only the file that ends with `977.fastq`.


!!! terminal-2 "Lists every file in `/usr/bin` that ends with the characters `11`"

    ```bash
    $ ls /usr/bin/*11
    ```

    ```output
    /usr/bin/cpp-11  /usr/bin/gcc-ar-11      /usr/bin/gcov-11       /usr/bin/lto-dump-11              /usr/bin/x86_64-linux-gnu-gcc-11     /usr/bin/x86_64-linux-gnu-gcc-ranlib-11  /usr/bin/x86_64-linux-gnu-gcov-tool-11
    /usr/bin/g++-11  /usr/bin/gcc-nm-11      /usr/bin/gcov-dump-11  /usr/bin/x86_64-linux-gnu-cpp-11  /usr/bin/x86_64-linux-gnu-gcc-ar-11  /usr/bin/x86_64-linux-gnu-gcov-11        /usr/bin/x86_64-linux-gnu-lto-dump-11
    /usr/bin/gcc-11  /usr/bin/gcc-ranlib-11  /usr/bin/gcov-tool-11  /usr/bin/x86_64-linux-gnu-g++-11  /usr/bin/x86_64-linux-gnu-gcc-nm-11  /usr/bin/x86_64-linux-gnu-gcov-dump-11
    ```

    Note that the output displays **full** paths to files, since each result starts with `/`.

 

!!! dumbbell "Exercise"

    Do each of the following tasks from your current directory using a single
    `ls` command for each:
 
     1. List all of the files in `/usr/bin` that start with the letter 'c'.
     2. List all of the files in `/usr/bin` that contain the letter 'a'.
     3. List all of the files in `/usr/bin` that end with the letter 'o'.
 
     Bonus: List all of the files in `/usr/bin` that contain the letter 'a' or the
     letter 'c'.
     
     Hint: The bonus question requires a Unix wildcard that we haven't talked about
     yet. Try searching the internet for information about Unix wildcards to find
     what you need to solve the bonus problem.



    ??? success "Solution"
    
        1. `ls /usr/bin/c*`
        2. `ls /usr/bin/*a*`
        3. `ls /usr/bin/*o`  
           Bonus: `ls /usr/bin/*[ac]*`


!!! dumbbell "Exercise"

    `echo` is a built-in shell command that writes its arguments, like a line of text to standard output.
    The `echo` command can also be used with pattern matching characters, such as wildcard characters.
    Here we will use the `echo` command to see how the wildcard character is interpreted by the shell.
    
    ```bash
    $ echo *.fastq
    ```
    
    ```output
    SRR097977.fastq SRR098026.fastq
    ```

    The `*` is expanded to include any file that ends with `.fastq`. We can see that the output of
    `echo *.fastq` is the same as that of `ls *.fastq`.
    
    What would the output look like if the wildcard could _not_ be matched? Compare the outputs of
    `echo *.missing` and `ls *.missing`.

    ??? success "Solution"
    
        ```bash
        $ echo *.missing
        ```
        
        ```output
        *.missing
        ```
        
        ```bash
        $ ls *.missing
        ```
        
        ```output
        ls: cannot access '*.missing': No such file or directory
        ```


## Command History

If you want to repeat a command that you've run recently, you can access previous
commands using the up arrow on your keyboard to go back to the most recent
command. Likewise, the down arrow takes you forward in the command history.

A few more useful shortcuts:

- <kbd>Ctrl</kbd>\+<kbd>C</kbd> will cancel the command you are writing, and give you a
  fresh prompt.
- <kbd>Ctrl</kbd>\+<kbd>R</kbd> will do a reverse-search through your command history. This
  is very useful.
- <kbd>Ctrl</kbd>\+<kbd>L</kbd> or the `clear` command will clear your screen.

!!! terminal -2 "You can also review your recent commands with the `history` command, by entering:"

    ```bash
    $ history
    ```

to see a numbered list of recent commands. You can reuse one of these commands
directly by referring to the number of that command.

!!! terminal-2 "For example, if your history looked like this:"

    ```output
    259  ls *
    260  ls /usr/bin/*.sh
    261  ls *R1*fastq
    ```

!!! terminal -2 "then you could repeat command #260 by entering:"

    ```bash
    $ !260
    ```

Type `!` (exclamation point) and then the number of the command from your history.
You will be glad you learned this when you need to re-run very complicated commands.
For more information on advanced usage of `history`, read section 9.3 of
[Bash manual](https://www.gnu.org/software/bash/manual/html_node/index.html).


!!! dumbbell "Exercise"

    Find the line number in your history for the command that listed all the .sh
    files in `/usr/bin`. Rerun that command.

    ??? success "solution"

        First type `history`. Then use `!` followed by the line number to rerun that command.

## Examining Files

We now know how to switch directories, run programs, and look at the
contents of directories, but how do we look at the contents of files?

One way to examine a file is to print out all of the
contents using the program `cat`.

Enter the following command from within the `untrimmed_fastq` directory:

!!! terminal "code"

    ```bash
    $ cat SRR098026.fastq
    ```

This will print out all of the contents of the `SRR098026.fastq` to the screen.



!!! dumbbell "Exercise"

    1. Print out the contents of the `~/shell_data/untrimmed_fastq/SRR097977.fastq` file. What is the last line of the file?
    2. From your home directory, and without changing directories,
       use one short command to print the contents of all of the files in
       the `~/shell_data/untrimmed_fastq` directory.

    
    
    ??? success "Solution"
    
        1. The last line of the file is `C:CCC::CCCCCCCC<8?6A:C28C<608'&&&,'$`.
        2. `cat ~/shell_data/untrimmed_fastq/*`


`cat` is a terrific program, but when the file is really big, it can
be annoying to use. The program, `less`, is useful for this
case. `less` opens the file as read only, and lets you navigate through it. The navigation commands
are identical to the `man` program.

!!! terminal-2 "Enter the following command:"

    ```bash
    $ less SRR097977.fastq
    ```

Some navigation commands in `less`:

| key              | action                 |
| ---------------- | ---------------------- |
| <kbd>Space</kbd> | to go forward          |
| <kbd>b</kbd>     | to go backward         |
| <kbd>g</kbd>     | to go to the beginning |
| <kbd>G</kbd>     | to go to the end       |
| <kbd>q</kbd>     | to quit                |

`less` also gives you a way of searching through files. Use the
"/" key to begin a search. Enter the word you would like
to search for and press `enter`. The screen will jump to the next location where
that word is found.

**Shortcut:** If you hit "/" then "enter", `less` will repeat
the previous search. `less` searches from the current location and
works its way forward. Scroll up a couple lines on your terminal to verify
you are at the beginning of the file. Note, if you are at the end of the file and search
for the sequence "CAA", `less` will not find it. You either need to go to the
beginning of the file (by typing `g`) and search again using `/` or you
can use `?` to search backwards in the same way you used `/` previously.

For instance, let's search forward for the sequence `TTTTT` in our file.
You can see that we go right to that sequence, what it looks like,
and where it is in the file. If you continue to type `/` and hit return, you will move
forward to the next instance of this sequence motif. If you instead type `?` and hit
return, you will search backwards and move up the file to previous examples of this motif.


!!! dumbbell "Exercise"

    What are the next three nucleotides (characters) after the first instance of the sequence quoted above?



    ??? success "Solution"
    
        `CAC`

Remember, the `man` program actually uses `less` internally and
therefore uses the same commands, so you can search documentation
using "/" as well!

There's another way that we can look at files, and in this case, just
look at part of them. This can be particularly useful if we just want
to see the beginning or end of the file, or see how it's formatted.

The commands are `head` and `tail` and they let you look at
the beginning and end of a file, respectively.

!!! terminal "code"
    
    ```bash
    $ head SRR098026.fastq
    ```

    ```output
    @SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
    NNNNNNNNNNNNNNNNCNNNNNNNNNNNNNNNNNN
    +SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
    !!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
    @SRR098026.2 HWUSI-EAS1599_1:2:1:0:312 length=35
    NNNNNNNNNNNNNNNNANNNNNNNNNNNNNNNNNN
    +SRR098026.2 HWUSI-EAS1599_1:2:1:0:312 length=35
    !!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
    @SRR098026.3 HWUSI-EAS1599_1:2:1:0:570 length=35
    NNNNNNNNNNNNNNNNANNNNNNNNNNNNNNNNNN
    ```
 
    ```bash
    $ tail SRR098026.fastq
    ```
 
    ```output
    +SRR098026.247 HWUSI-EAS1599_1:2:1:2:1311 length=35
    #!##!#################!!!!!!!######
    @SRR098026.248 HWUSI-EAS1599_1:2:1:2:118 length=35
    GNTGNGGTCATCATACGCGCCCNNNNNNNGGCATG
    +SRR098026.248 HWUSI-EAS1599_1:2:1:2:118 length=35
    B!;?!A=5922:##########!!!!!!!######
    @SRR098026.249 HWUSI-EAS1599_1:2:1:2:1057 length=35
    CNCTNTATGCGTACGGCAGTGANNNNNNNGGAGAT
    +SRR098026.249 HWUSI-EAS1599_1:2:1:2:1057 length=35
    A!@B!BBB@ABAB#########!!!!!!!######
    ```

!!! terminal-2 "The `-n` option to either of these commands can be used to print the first or last `n` lines of a file."

    ```bash
    $ head -n 1 SRR098026.fastq
    ```
    
    ```output
    @SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
    ```
    
    ```bash
    $ tail -n 1 SRR098026.fastq
    ```

    ```output
    A!@B!BBB@ABAB#########!!!!!!!######
    ```

## Details on the FASTQ format

Although it looks complicated (and it is), it's easy to understand the
[fastq](https://en.wikipedia.org/wiki/FASTQ_format) format with a little decoding. Some rules about the format
include...

| Line | Description                                                                                                  |
| ---- | ------------------------------------------------------------------------------------------------------------ |
| 1    | Always begins with '@' and then information about the read                                                   |
| 2    | The actual DNA sequence                                                                                      |
| 3    | Always begins with a '+' and sometimes the same info in line 1                                               |
| 4    | Has a string of characters which represent the quality scores; must have same number of characters as line 2 |

We can view the first complete read in one of the files in our dataset by using `head` to look at
the first four lines.

!!! terminal "code"
    
    ```bash
    $ head -n 4 SRR098026.fastq
    ```
    
    ```output
    @SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
    NNNNNNNNNNNNNNNNCNNNNNNNNNNNNNNNNNN
    +SRR098026.1 HWUSI-EAS1599_1:2:1:0:968 length=35
    !!!!!!!!!!!!!!!!#!!!!!!!!!!!!!!!!!!
    ```

All but one of the nucleotides in this read are unknown (`N`). This is a pretty bad read!
Line 4 shows the quality for each nucleotide in the read. You can read more about the Fastq format here on [Illumina reference material](https://knowledge.illumina.com/software/general/software-general-reference_material-list/000002211) or on [Wikipedia](https://en.wikipedia.org/wiki/FASTQ_format). 

## Creating, moving, copying, and removing

Now we can move around in the file structure, look at files, and search files. But what if we want to copy files or move
them around or get rid of them? Most of the time, you can do these sorts of file manipulations without the command line,
but there will be some cases (like when you're working with a remote computer like we are for this lesson) where it will be
impossible. You'll also find that you may be working with hundreds of files and want to do similar manipulations to all
of those files. In cases like this, it's much faster to do these operations at the command line.

### Copying Files

When working with computational data, it's important to keep a safe copy of that data that can't be accidentally overwritten or deleted.
For this lesson, our raw data is our FASTQ files. We don't want to accidentally change the original files, so we'll make a copy of them
and change the file permissions so that we can read from, but not write to, the files.

First, let's make a copy of one of our FASTQ files using the `cp` command.

!!! terminal-2 "Navigate to the `~/shell_data/untrimmed_fastq` directory and enter:"

    ```bash
    $ cp SRR098026.fastq SRR098026-copy.fastq
    $ ls -F
    ```

    ```output
    SRR097977.fastq  SRR098026-copy.fastq  SRR098026.fastq
    ```

We now have two copies of the `SRR098026.fastq` file, one of them named `SRR098026-copy.fastq`. We'll move this file to a new directory
called `backup` where we'll store our backup data files.

### Creating Directories

!!! terminal-2 "The `mkdir` command is used to make a directory. Enter `mkdir` followed by a space, then the directory name you want to create:"

    ```bash
    $ mkdir backup
    ```

### Moving / Renaming

!!! terminal-2 "We can now move our backup file to this directory. We can move files around using the command `mv`:"


    ```bash
    $ mv SRR098026-copy.fastq backup
    $ ls backup
    ```
    
    ```output
    SRR098026-copy.fastq
    ```

!!! terminal-2 "The `mv` command is also how you rename files. Let's rename this file to make it clear that this is a backup:"

    ```bash
    $ cd backup
    $ mv SRR098026-copy.fastq SRR098026-backup.fastq
    $ ls
    ```
    
    ```output
    SRR098026-backup.fastq
    ```

### File Permissions

We've now made a backup copy of our file, but just because we have two copies, it doesn't make us safe. We can still accidentally delete or
overwrite both copies. To make sure we can't accidentally mess up this backup file, we're going to change the permissions on the file so
that we're only allowed to read (i.e. view) the file, not write to it (i.e. make new changes).

!!! terminal-2 "View the current permissions on a file using the `-l` (long) flag for the `ls` command:"

    ```bash
    $ ls -l
    ```

    ```output
    -rw-r--r-- 1 training training 43332 Nov 15 23:02 SRR098026-backup.fastq
    ```

The first part of the output for the `-l` flag gives you information about the file's current permissions. There are ten slots in the
permissions list. The first character in this list is related to file type, not permissions, so we'll ignore it for now. The next three
characters relate to the permissions that the file owner has, the next three relate to the permissions for group members, and the final
three characters specify what other users outside of your group can do with the file. We're going to concentrate on the three positions
that deal with your permissions (as the file owner).

![](fig/rwx_figure.svg){alt='Permissions breakdown'}

Here the three positions that relate to the file owner are `rw-`. The `r` means that you have permission to read the file, the `w`
indicates that you have permission to write to (i.e. make changes to) the file, and the third position is a `-`, indicating that you
don't have permission to carry out the ability encoded by that space (this is the space where `x` or executable ability is stored, we'll
talk more about this in [a later lesson](05-writing-scripts.md)).

Our goal for now is to change permissions on this file so that you no longer have `w` or write permissions. We can do this using the `chmod` (change mode) command and subtracting (`-`) the write permission `-w`.

!!! terminal "code"

    ```bash
    $ chmod -w SRR098026-backup.fastq
    $ ls -l
    ```

    ```output
    -r--r--r-- 1 training training 43332 Nov 15 23:02 SRR098026-backup.fastq
    ```

### Removing

To prove to ourselves that you no longer have the ability to modify this file, try deleting it with the `rm` command:

!!! terminal "code"

    ```bash
    $ rm SRR098026-backup.fastq
    ```

You'll be asked if you want to override your file permissions:

```output
rm: remove write-protected regular file ‘SRR098026-backup.fastq'?
```

You should enter `n` for no. If you enter `n` (for no), the file will not be deleted. If you enter `y`, you will delete the file. This gives us an extra
measure of security, as there is one more step between us and deleting our data files.

**Important**: The `rm` command permanently removes the file. Be careful with this command. It doesn't
just nicely put the files in the Trash. They're really gone.

By default, `rm` will not delete directories. You can tell `rm` to
delete a directory using the `-r` (recursive) option. Let's delete the backup directory
we just made.

!!! terminal-2 "Enter the following command:"

    ```bash
    $ cd ..
    $ rm -r backup
    ```

   This will delete not only the directory, but all files within the directory. If you have write-protected files in the directory, you will be asked whether you want to override your permission settings.



!!! dumbbell "Exercise"

    Starting in the `~/shell_data/untrimmed_fastq/` directory, do the following:
    
    1. Make sure that you have deleted your backup directory and all files it contains.
    2. Create a backup of each of your FASTQ files using `cp`. (Note: You'll need to do this individually for each of the two FASTQ files. We haven't
       learned yet how to do this
       with a wildcard.)
    3. Use a wildcard to move all of your backup files to a new backup directory.
    4. Change the permissions on all of your backup files to be write-protected.
    

    ??? success "Solution"

        1. `rm -r backup`
        2. `cp SRR098026.fastq SRR098026-backup.fastq` and `cp SRR097977.fastq SRR097977-backup.fastq`
        3. `mkdir backup` and `mv *-backup.fastq backup`
        4. `chmod -w backup/*-backup.fastq`  
           It's always a good idea to check your work with `ls -l backup`. You should see something like:
        
         ```output
         -r--r--r-- 1 training training 47552 Nov 15 23:06 SRR097977-backup.fastq
         -r--r--r-- 1 training training 43332 Nov 15 23:06 SRR098026-backup.fastq
         ```

!!! graduation-cap "keypoints"

    - You can view file contents using `less`, `cat`, `head` or `tail`.
    - The commands `cp`, `mv`, and `mkdir` are useful for manipulating existing files and creating new directories.
    - You can view file permissions using `ls -l` and change permissions using `chmod`.
    - The `history` command and the up arrow on your keyboard can be used to repeat recently used commands.

