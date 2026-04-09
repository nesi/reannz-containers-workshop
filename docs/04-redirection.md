# 4. Redirection


!!! clipboard-list "Lesson Objectives"

    - Employ the `grep` command to search for information within files.
    - Print the results of a command to a file.
    - Construct command pipelines with two or more stages.
    - Use `for` loops to run the same command for several input files.

!!! clipboard-question "questions"

    - How can I search within files?
    - How can I combine existing commands to do new things?



## Searching files

We discussed in a previous episode how to search within a file using `less`. We can also
search within files without even opening them, using `grep`. `grep` is a command-line
utility for searching plain-text files for lines matching a specific set of
characters (sometimes called a string) or a particular pattern
(which can be specified using something called regular expressions). We're not going to work with
regular expressions in this lesson, and are instead going to specify the strings
we are searching for.
Let's give it a try!



## Nucleotide abbreviations

The four nucleotides that appear in DNA are abbreviated `A`, `C`, `T` and `G`.
Unknown nucleotides are represented with the letter `N`. An `N` appearing
in a sequencing file represents a position where the sequencing machine was not able to
confidently determine the nucleotide in that position. You can think of an `N` as being aNy
nucleotide at that position in the DNA sequence.



We'll search for strings inside of our fastq files. Let's first make sure we are in the correct
directory:

!!! terminal "code"

    ```bash
    $ cd ~/shell_data/untrimmed_fastq
    ```

Suppose we want to see how many reads in our file have really bad segments containing 10 consecutive unknown nucleotides (Ns).



## Determining quality

In this lesson, we're going to be manually searching for strings of `N`s within our sequence
results to illustrate some principles of file searching. It can be really useful to do this
type of searching to get a feel for the quality of your sequencing results, however, in your
research you will most likely use a bioinformatics tool that has a built-in program for
filtering out low-quality reads. You can learn how to use one such tool, called FastQC, in this
[Data Carpentry lesson on Data Wrangling and Processing for Genomics](https://datacarpentry.org/wrangling-genomics/02-quality-control) or as part of our other workshops [RNA-seq Data Analysis](https://genomicsaotearoa.github.io/BioinformaticsTrainingProgramme/portfolio.html#rna-seq-data-analysis) or [Microbial genome assembly with short reads](https://genomicsaotearoa.github.io/BioinformaticsTrainingProgramme/portfolio.html#microbial-genome-assembly-with-short-reads).



!!! terminal-2 "Let's search for the string `NNNNNNNNNN` in the SRR098026 file:"


    ```bash
    $ grep NNNNNNNNNN SRR098026.fastq
    ```

This command returns a lot of output to the terminal. Every single line in the SRR098026
file that contains at least 10 consecutive `N`s is printed to the terminal, regardless of how long or short the file is.
We may be interested not only in the actual sequence which contains this string, but
in the name (or identifier) of that sequence. We discussed in a previous lesson
that the identifier line immediately precedes the nucleotide sequence for each read
in a FASTQ file. We may also want to inspect the quality scores associated with
each of these reads. To get all of this information, we will return the line
immediately before each match and the two lines immediately after each match.

We can use the `-B` argument for grep to return a specific number of lines before
each match. The `-A` argument returns a specific number of lines after each matching line. Here we want the line _before_ and the two lines _after_ each
matching line, so we add `-B1 -A2` to our grep command:

!!! terminal-2 "code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
    ```

    One of the sets of lines returned by this command is:
    
    ```output
    @SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
    +SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ```
    ??? tip "Can we avoid typiing `N` 10 times as it is a bit tedious 😵‍💫"

        Sure can. Use 
        ```bash
        grep -E -B1 -A2 "N{10}" SRR098026.fastq
        ```

        - `-E`: This option tells grep to use Extended Regular Expressions (ERE). In ERE, certain characters like {}, (), ?, +, and | have special meanings without needing to be escaped. This is crucial for our pattern N{10} to work as intended.
        - `"N{10}":` This is the pattern we're searching for:
            - `N` represents the literal character 'N'.
            - `{10}` is a quantifier that means "exactly 10 times".
            - Together, `N{10}` matches exactly 10 consecutive 'N' characters.


!!! dumbbell "Exercise"

    1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file.
       Have your search return all matching lines and the name (or identifier) for each sequence
       that contains a match.
    
    2. Search for the sequence `AAGTT` in both FASTQ files.
       Have your search return all matching lines and the name (or identifier) for each sequence
       that contains a match

    ??? success "Solution"

        1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`

            ```
            @SRR098026.245 HWUSI-EAS1599_1:2:1:2:801 length=35
            GNATNACCACTTCCAGTGCTGANNNNNNNGGGATG
            ```

        2. `grep -B1 AAGTT *.fastq`
        
            ```
            SRR097977.fastq-@SRR097977.11 209DTAAXX_Lenski2_1_7:8:3:247:351 length=36
            SRR097977.fastq:GATTGCTTTAATGAAAAAGTCATATAAGTTGCCATG
            --
            SRR097977.fastq-@SRR097977.67 209DTAAXX_Lenski2_1_7:8:3:544:566 length=36
            SRR097977.fastq:TTGTCCACGCTTTTCTATGTAAAGTTTATTTGCTTT
            --
            SRR097977.fastq-@SRR097977.68 209DTAAXX_Lenski2_1_7:8:3:724:110 length=36
            SRR097977.fastq:TGAAGCCTGCTTTTTTATACTAAGTTTGCATTATAA
            --
            SRR097977.fastq-@SRR097977.80 209DTAAXX_Lenski2_1_7:8:3:258:281 length=36
            SRR097977.fastq:GTGGCGCTGCTGCATAAGTTGGGTTATCAGGTCGTT
            --
            SRR097977.fastq-@SRR097977.92 209DTAAXX_Lenski2_1_7:8:3:353:318 length=36
            SRR097977.fastq:GGCAAAATGGTCCTCCAGCCAGGCCAGAAGCAAGTT
            --
            SRR097977.fastq-@SRR097977.139 209DTAAXX_Lenski2_1_7:8:3:703:655 length=36
            SRR097977.fastq:TTTATTTGTAAAGTTTTGTTGAAATAAGGGTTGTAA
            --
            SRR097977.fastq-@SRR097977.238 209DTAAXX_Lenski2_1_7:8:3:592:919 length=36
            SRR097977.fastq:TTCTTACCATCCTGAAGTTTTTTCATCTTCCCTGAT
            --
            SRR098026.fastq-@SRR098026.158 HWUSI-EAS1599_1:2:1:1:1505 length=35
            SRR098026.fastq:GNNNNNNNNCAAAGTTGATCNNNNNNNNNTGTGCG
            ```


## Redirecting output

`grep` allowed us to identify sequences in our FASTQ files that match a particular pattern.
All of these sequences were printed to our terminal screen, but in order to work with these
sequences and perform other operations on them, we will need to capture that output in some
way.

We can do this with something called "redirection". The idea is that
we are taking what would ordinarily be printed to the terminal screen and redirecting it to another location.
In our case, we want to print this information to a file so that we can look at it later and
use other commands to analyse this data.

The command for redirecting output to a file is `>`.

Let's try out this command and copy all the records (including all four lines of each record)
in our FASTQ files that contain
'NNNNNNNNNN' to another file called `bad_reads.txt`.

!!! terminal "Code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
    ```

    -  You will notice the `NNNN..` characters aren't highlighted in red anymore. Perhaps `grep` might have a flag to retain the colour for searched pattern ?


!!! circle-info "File extensions"

    You might be confused about why we're naming our output file with a `.txt` extension. After all,
    it will be holding FASTQ formatted data that we're extracting from our FASTQ files. Won't it
    also be a FASTQ file? The answer is, yes - it will be a FASTQ file and it would make sense to
    name it with a `.fastq` extension. However, using a `.fastq` extension will lead us to problems
    when we move to using wildcards later in this episode. We'll point out where this becomes
    important. For now, it's good that you're thinking about file extensions!



The prompt should sit there a little bit, and then it should look like nothing
happened. But type `ls`. You should see a new file called `bad_reads.txt`.

We can check the number of lines in our new file using a command called `wc`.
`wc` stands for **word count**. This command counts the number of words, lines, and characters
in a file. The FASTQ file may change over time, so given the potential for updates,
make sure your file matches your instructor's output.

!!! terminal-2 "Code"

    ```bash
    $ wc bad_reads.txt
    ```

    ```output
    537  1073 23217  bad_reads.txt
    ```

    This will tell us the number of lines, words and characters in the file. If we
    want only the number of lines, we can use the `-l` flag for `lines`.
    
    ```bash
    $ wc -l bad_reads.txt
    ```
    
    ```output
    537 bad_reads.txt
    ```

!!! dumbbell "Exercise"

    How many sequences are there in `SRR098026.fastq`? Remember that every sequence is formed by four lines.



    ??? success "Solution"
    
        ```bash
        $ wc -l SRR098026.fastq
        ```

        ```output
        996
        ```

    Now you can divide this number by four to get the number of sequences in your fastq file.


!!! dumbbell "Exercise"

    How many sequences in `SRR098026.fastq` contain at least 3 consecutive Ns?

    ??? success "Solution"
    
        ```bash
        $ grep NNN SRR098026.fastq > bad_reads.txt
        $ wc -l bad_reads.txt
        ```

        ```output
        249
        ```


We might want to search multiple FASTQ files for sequences that match our search pattern.
However, we need to be careful, because each time we use the `>` command to redirect output
to a file, the new output will replace the output that was already present in the file.
This is called "overwriting" and, just like you don't want to overwrite your video recording
of your kid's first birthday party, you also want to avoid overwriting your data files.

!!! terminal "code"
    
    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
    $ wc -l bad_reads.txt
    ```
    
    ```output
    537 bad_reads.txt
    ```
!!! terminal "code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq > bad_reads.txt
    $ wc -l bad_reads.txt
    ```
    
    ```output
    0 bad_reads.txt
    ```

Here, the output of our second call to `wc` shows that we no longer have any lines in our `bad_reads.txt` file. This is
because the second file we searched (`SRR097977.fastq`) does not contain any lines that match our
search sequence. So our file was overwritten and is now empty.

!!! terminal-2 "We can avoid overwriting our files by using the command `>>`. `>>` is known as the "append redirect" and will append new output to the end of a file, rather than overwriting it."


    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
    $ wc -l bad_reads.txt
    ```
    
    ```output
    537 bad_reads.txt
    ```
    
    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt
    $ wc -l bad_reads.txt
    ```
    
    ```output
    537 bad_reads.txt
    ```

The output of our second call to `wc` shows that we have not overwritten our original data.

!!! terminal-2 "We can also do this with a single line of code by using a wildcard:"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.txt
    $ wc -l bad_reads.txt
    ```
    
    ```output
    537 bad_reads.txt
    ```


!!! circle-info "File extensions - part 2"

    This is where we would have trouble if we were naming our output file with a `.fastq` extension.
    If we already had a file called `bad_reads.fastq` (from our previous `grep` practice)
    and then ran the command above using a `.fastq` extension instead of a `.txt` extension, `grep`
    would give us a warning.

    !!! terminal "Code"

        ```bash
        grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.fastq
        ```

        ```output
        grep: input file ‘bad_reads.fastq' is also the output
        ```

    `grep` is letting you know that the output file `bad_reads.fastq` is also included in your
    `grep` call because it matches the `*.fastq` pattern. Be careful with this as it can lead to
    some unintended results.



Since we might have multiple different criteria we want to search for,
creating a new output file each time has the potential to clutter up our workspace. We also
thus far haven't been interested in the actual contents of those files, only in the number of
reads that we've found. We created the files to store the reads and then counted the lines in
the file to see how many reads matched our criteria. There's a way to do this, however, that
doesn't require us to create these intermediate files - the pipe command (`|`).

This is probably not a key on
your keyboard you use very much, so let's all take a minute to find that key.
In the UK and US keyboard layouts, and several others,
the `|` character can be found using the key combination <kbd>Shift</kbd>\+<kbd>\</kbd>.
This may be different for other language-specific layouts.

What `|` does is take the output that is scrolling by on the terminal and uses that output as input to another command.
When our output was scrolling by, we might have wished we could slow it down and
look at it, like we can with `less`. Well it turns out that we can! We can redirect our output
from our `grep` call through the `less` command.

!!! terminal "code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | less
    ```

We can now see the output from our `grep` call within the `less` interface. We can use the up and down arrows
to scroll through the output and use `q` to exit `less`.

If we don't want to create a file before counting lines of output from our `grep` search, we could directly pipe
the output of the grep search to the command `wc -l`. This can be helpful for investigating your output if you are not sure
you would like to save it to a file.

!!! terminal "Code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | wc -l
    ```

Because we asked `grep` for all four lines of each FASTQ record, we need to divide the output by
four to get the number of sequences that match our search pattern. Since 802 / 4 = 200.5 and we
are expecting an integer number of records, there is something added or missing in `bad_reads.txt`.
If we explore `bad_reads.txt` using `less`, we might be able to notice what is causing the uneven
number of lines. Luckily, this issue happens by the end of the file so we can also spot it with `tail`.

!!! terminal "code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
    $ tail bad_reads.txt
    ```

    ```output
    @SRR098026.133 HWUSI-EAS1599_1:2:1:0:1978 length=35
    ANNNNNNNNNTTCAGCGACTNNNNNNNNNNGTNGN
    +SRR098026.133 HWUSI-EAS1599_1:2:1:0:1978 length=35
    #!!!!!!!!!##########!!!!!!!!!!##!#!
    --
    --
    @SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
    +SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ```

The sixth line in the output display "--" which is the default action for `grep` to separate groups of
lines matching the pattern, and indicate groups of lines which did not match the pattern so are not displayed.
To fix this issue, we can redirect the output of grep to a second instance of `grep` as follows.

!!! terminal "code"

    ```bash
    $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | grep -v '^--' > bad_reads.txt
    $ tail bad_reads.txt
    ```

    ```output
    +SRR098026.132 HWUSI-EAS1599_1:2:1:0:320 length=35
    #!!!!!!!!!##########!!!!!!!!!!##!#!
    @SRR098026.133 HWUSI-EAS1599_1:2:1:0:1978 length=35
    ANNNNNNNNNTTCAGCGACTNNNNNNNNNNGTNGN
    +SRR098026.133 HWUSI-EAS1599_1:2:1:0:1978 length=35
    #!!!!!!!!!##########!!!!!!!!!!##!#!
    @SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
    +SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ```

    - `-v`: This option tells grep to invert the match, meaning it will return lines that do not match the specified pattern.
    - `'^--'`: This is a regular expression where:
    `^` asserts that the following characters (`--`) must be at the start of the line.



!!! circle-info "Custom `grep` control"

    Use `man grep` to read more about other options to customise the output of `grep` including extended options,
    anchoring characters, and much more.



Redirecting output is often not intuitive, and can take some time to get used to. Once you're
comfortable with redirection, however, you'll be able to combine any number of commands to
do all sorts of exciting things with your data!

None of the command line programs we've been learning
do anything all that impressive on their own, but when you start chaining
them together, you can do some really powerful things very
efficiently.


!!! circle-info  "File manipulation and more practices with pipes"

    To practice a bit more with the tools we've added to our tool kit so far and learn a few extra ones you can follow [this extra lesson](./Supplementary/1-supplementary.md) which uses the SRA metadata file.



## Writing for loops

Loops are key to productivity improvements through automation as they allow us to execute commands repeatedly.
Similar to wildcards and tab completion, using loops also reduces the amount of typing (and typing mistakes).
Loops are helpful when performing operations on groups of sequencing files, such as unzipping or trimming multiple
files. We will use loops for these purposes in subsequent analyses, but will cover the basics of them for now.

When the shell sees the keyword `for`, it knows to repeat a command (or group of commands) once for each item in a list.
Each time the loop runs (called an iteration), an item in the list is assigned in sequence to the **variable**, and
the commands inside the loop are executed, before moving on to the next item in the list. Inside the loop, we call for
the variable's value by putting `$` in front of it. The `$` tells the shell interpreter to treat the **variable**
as a variable name and substitute its value in its place, rather than treat it as text or an external command. In shell programming, this is usually called "expanding" the variable.

!!! circle-info "Basic Structure of a `for` loop"

    The basic structure of a bash for loop looks like this:
    ```bash
    for variable in list
    do
        commands
    done
    ```

    Let's break down each part:

    1. `for`: This keyword starts the loop.
    2. `variable`: This is a temporary variable that takes on each value in the list, one at a time.
    3. `in`: This keyword separates the variable from the list.
    4. `list`: This is the set of items you want to loop through.
    5. `do`: This keyword marks the beginning of the commands to be executed in each iteration.
    6. `commands`: These are the actions you want to perform for each item in the list.
    7. `done`: This keyword marks the end of the loop.

    
    Here's a simple example to help you understand:
    ```bash
    for fruit in apple banana orange
    do
        echo "I like $fruit"
    done
    ```
    This loop will output:
    ```
    I like apple
    I like banana
    I like orange
    ```

    How does it work: 

    1. The loop starts with "apple" as the value of fruit.
    2. It executes the echo command with this value.
    3. Then it moves to the next item, "banana", and repeats.
    4. Finally, it does the same with "orange".
    
    After the last item, the loop ends.
    
    Remember, you can put any commands inside the loop, and they will be executed for each item in your list. This makes for loops a powerful tool for automating repetitive tasks in bash scripting.


!!! list-check "Let's write a for loop to show us the first two lines of the fastq files we downloaded earlier. You will notice the shell prompt changes from `$` to `>` and back again as we were typing in our loop. The second prompt, `>`, is different to remind us that we haven't finished typing a complete command yet."

    ```bash
    $ cd ../untrimmed_fastq/
    ```

    ```bash
    $ for filename in *.fastq
    > do
    > head -n 2 ${filename}
    > done
    ```

    The for loop begins with the formula `for <variable> in <group to iterate over>`. In this case, the word `filename` is designated
    as the variable to be used over each iteration. In our case `SRR097977.fastq` and `SRR098026.fastq` will be substituted for `filename`
    because they fit the pattern of ending with .fastq in the directory we've specified. The next line of the for loop is `do`. The next line is
    the code that we want to execute. We are telling the loop to print the first two lines of each variable we iterate over. Finally, the
    word `done` ends the loop.

    After executing the loop, you should see the first two lines of both fastq files printed to the terminal. Let's create a loop that
    will save this information to a file.

    ```bash
    $ for filename in *.fastq
    > do
    > head -n 2 ${filename} >> seq_info.txt
    > done
    ```

When writing a loop, you will not be able to return to previous lines once you have pressed Enter. Remember that we can cancel the current command using

- <kbd>Ctrl</kbd>\+<kbd>C</kbd>

If you notice a mistake that is going to prevent your loop for executing correctly.

Note that we are using `>>` to append the text to our `seq_info.txt` file. If we used `>`, the `seq_info.txt` file would be rewritten
every time the loop iterates, so it would only have text from the last variable used. Instead, `>>` adds to the end of the file.

## Using Basename in for loops

Basename is a function in UNIX that is helpful for removing a uniform part of a name from a list of files. In this case, we will use basename to remove the `.fastq` extension from the files that we've been working with.

!!! terminal "code"

    ```bash
    $ basename SRR097977.fastq .fastq
    ```

    We see that this returns just the SRR accession, and no longer has the .fastq file extension on it.

    ```output
    SRR097977
    ```

If we try the same thing but use `.fasta` as the file extension instead, nothing happens. This is because basename only works when it **exactly** matches a string in the file.

!!! terminal "Cdoe"

    ```bash
    $ basename SRR097977.fastq .fasta
    ```

    ```output
    SRR097977.fastq
    ```

!!! quote ""
    Basename is really powerful when used in a for loop. It allows to access just the file prefix, which you can use to name things. Let's try this.

Inside our for loop, we create a new name variable. We call the basename function inside the parenthesis, then give our variable name from the for loop, in this case `${filename}`, and finally state that `.fastq` should be removed from the file name. It's important to note that we're not changing the actual files, we're creating a new variable called name. The line > echo $name will print to the terminal the variable name each time the for loop runs. Because we are iterating over two files, we expect to see two lines of output.

!!! terminal "code"

    ```bash
    $ for filename in *.fastq
    > do
    > name=$(basename ${filename} .fastq)
    > echo ${name}
    > done
    ```

    Why Parentheses `()` ?

    - **Command Substitution:** The `$(...)` syntax is used for command substitution. It allows you to execute a command and use its output as a value in your script. In this case, `$(basename ${filename} .fastq)` executes the `basename` command and captures its output, which is then assigned to the variable name.
    - **Clarity:** Using `$(...)` is preferred over backticks (`...`) for command substitution because it is more readable and can be nested more easily.

    Why Curly Braces `{}` ?

    - **Variable Expansion:** The `${filename}` syntax is used to clearly indicate that you are referencing the variable `filename`. This is particularly useful in cases where the variable name might be adjacent to other characters that could be interpreted as part of the variable name.
    - **Disambiguation:** For example, if you had a variable named `filename_suffix`, writing `$filename_suffix` could lead to ,especially if you are trying to concatenate or manipulate it with other strings. Using `${filename}` makes it clear where the variable name ends.
    - **Consistency:** While not always required, using curly braces for variable expansion is a common practice that enhances readability and reduces the risk of errors.
    
    * * * 

    🙋 : **In  `name=$(basename ${filename} .fastq)`, Can  I switch `{}` and `()` as in `name=${basename $(filename) .fastq}` ?** 🚫

    - **Order Matters:** You must use `()` for command substitution first, and within that, you can use `{}` for variable expansion as needed.
    - **Contextual Importance:** Always use `$(...)` for command substitution and `${...}` for variable expansion to ensure clarity and correctness in your scripts.

    In summary, while the two types of brackets serve different purposes, their correct order and usage are crucial for the intended functionality of your shell scripts.

!!! dumbbell "Exercise"

    Print the file prefix of all of the `.txt` files in our current directory.


    ??? success "Solution"

        ```bash
        $ for filename in *.txt
        > do
        > name=$(basename ${filename} .txt)
        > echo ${name}
        > done
        ```


!!! terminal-2 "One way this is really useful is to move files. Let's rename all of our .txt files using `mv` so that they have the years on them, which will document when we created them."

    ```bash
    $ for filename in *.txt
    > do
    > name=$(basename ${filename} .txt)
    > mv ${filename}  ${name}_2019.txt
    > done
    ```

    - `mv ${filename} ${name}_2019.txt:`This line renames the file. 
        - `${filename}` is the original file name.
        - `${name}_2019.txt` is the new file name, which consists of the original name (without .txt), followed by "_2019.txt".

!!! dumbbell "Exercise"

    Remove `_2019` from all of the `.txt` files.



    ??? success "Solution"

        ```bash
        $ for filename in *_2019.txt
        > do
        > name=$(basename ${filename} _2019.txt)
        > mv ${filename} ${name}.txt
        > done
        ```


!!! graduation-cap "keypoints"

    - `grep` is a powerful search tool with many options for customisation.
    - `>`, `>>`, and `|` are different ways of redirecting output.
    - `command > file` redirects a command's output to a file.
    - `command >> file` redirects a command's output to a file without overwriting the existing contents of the file.
    - `command_1 | command_2` redirects the output of the first command as input to the second command.
    - `for` loops are used for iteration.
    - `basename` gets rid of repetitive parts of names.

