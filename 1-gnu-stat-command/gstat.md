# GNU core utilities on macOS

## Prompt

*Unix/Linux systems often come with the gnu stat command. It is useful for viewing systems-level information about a directory or file. On macs the stat command is not quite as useful and you might want to install the gnu stat command with the g prefix (gnu stat becomes gstat, leaving the original mac version of stat command intact).*

*See this stack overflow tip for more information:
<https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities>*

*Create files, directories, and nested directories and monitor the stat information. Also pay attention to the inode information. Can you explain how “Links” increments and decrements for directories and files? What command can you use to target a file via inode number? What are the Links in an empty directory? How do stat links relate to the ln function? While investigating this system, what were the most useful/informative commands? Document all your discoveries, experiments including commands and their results in a markdown document and submit to a public github account. We are interested in how deeply you investigate, how organized and thorough your notes are.*

## Installing GNU core utilities

Installing GNU core utilites with the g-prefix using `homebrew`, as indicated from the apple stackexhange posting. As mentioned in the prompt, as well as the dicussions on stackexchange, I believe keeping the g-prefix is a good idea, therefore I won't modify my `PATH` to use the commands without the prefix.

```zsh
~ ❯ brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
```

Checking the install of `coreutils`:

```zsh
~ ❯ brew info coreutils
==> coreutils: stable 9.1 (bottled), HEAD
GNU File, Shell, and Text utilities
https://www.gnu.org/software/coreutils
Conflicts with:
  aardvark_shell_utils (because both install `realpath` binaries)
  b2sum (because both install `b2sum` binaries)
  ganglia (because both install `gstat` binaries)
  gdu (because both install `gdu` binaries)
  idutils (because both install `gid` and `gid.1`)
  md5sha1sum (because both install `md5sum` and `sha1sum` binaries)
  truncate (because both install `truncate` binaries)
  uutils-coreutils (because coreutils and uutils-coreutils install the same binaries)
/opt/homebrew/Cellar/coreutils/9.1 (476 files, 13.2MB) *
  Poured from bottle on 2022-12-04 at 13:17:37
From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/coreutils.rb
License: GPL-3.0-or-later
==> Dependencies
Required: gmp ✔
==> Options
--HEAD
 Install HEAD version
==> Caveats
Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
==> Analytics
install: 74,938 (30 days), 242,091 (90 days), 1,199,696 (365 days)
install-on-request: 53,888 (30 days), 174,080 (90 days), 844,527 (365 days)
build-error: 68 (30 days)
```

`gstat` command on a file:

```zsh
~ ❯ gstat gene_signatures.csv
  File: gene_signatures.csv
  Size: 28288           Blocks: 56         IO Block: 4096   regular file
Device: 1,17    Inode: 39680265    Links: 1
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 16:16:12.479436278 +0100
Modify: 2022-12-03 13:35:18.648377033 +0100
Change: 2022-12-04 16:16:10.609054715 +0100
 Birth: 2022-04-06 16:24:47.000000000 +0200
```

`gstat` displays information about files and filesystems, with more detail than `ls -l`, including:

- File - The name of the file.
- Size - The size of the file in bytes.
- Blocks - The number of allocated blocks the file takes.
- IO Blocks - The size in bytes of every block.
- File type - regular file, directory, or symbolic link.
- Device - Device number in hex and decimal.
- Inode - The Inode number.
- Links - Number of hard links.
- Access - File permissions displayed in octal and rwx format.
- Uid - User ID and name of owner.
- Gid - Group ID and name of owner.
- Access - Last time the file was accessed, day, time, timezone.
- Modify - Last time the file's *content* was modified.
- Change - Last time the file's *attribute* was modified.
- Birth - File creation.

`gstat` can also be used to display information on a file system using the `-f` option:

```zsh
~ ❯ gstat -f gene_signatures.csv
  File: "gene_signatures.csv"
    ID: 10000110000001a Namelen: ?       Type: apfs
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 242837545  Free: 33868868   Available: 33868868
Inodes: Total: 1357041887 Free: 1354754720
```

This displays information on:

- File - The name of the file.
- ID - The file system ID in hex.
- Namelen - The maximum length of file names.
- Type - Type of file system.
- Fundamental block size - The size of each block in the file system.
- Blocks:
  - Total - Number of total blocks in the file system.
  - Free - Number of free blocks.
  - Available - Number of free blocks availble to non-root users.
- Inodes:
  - Total - Number of total inodes in the file system.
  - Free - Number of free inodes.

## Creating files

Here I am creating a new empty file titled "contact-info.txt" in my home directory. Then using `gstat` to display its information:

```zsh
~ ❯ touch contact-info.txt
~ ❯ gstat contact-info.txt 
  File: contact-info.txt
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 1,17    Inode: 39683408    Links: 1
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 16:39:19.649083657 +0100
Modify: 2022-12-04 16:39:19.649083657 +0100
Change: 2022-12-04 16:39:19.649083657 +0100
 Birth: 2022-12-04 16:39:19.649083657 +0100
```

Notes:

- Its an empty file so the size is 0.
- Interestingly, the type of file is "regular empty file", it can detect this, I didn't expect that.
- Inode # is 39683408.
- It has 1 link.

Now I will add a bit of information to this file:

```zsh
~ ❯ echo 'danieljgorski@gmail.com' > contact-info.txt
~ ❯ echo '+49 151-28791009' >> contact-info.txt
~ ❯ cat contact-info.txt
danieljgorski@gmail.com
+49 151-28791009
```

Then re-run `gstat` to monitor the changes:

```zsh
~ ❯ gstat contact-info.txt
  File: contact-info.txt
  Size: 41              Blocks: 8          IO Block: 4096   regular file
Device: 1,17    Inode: 39683408    Links: 1
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 16:46:45.501547836 +0100
Modify: 2022-12-04 16:46:44.241117819 +0100
Change: 2022-12-04 16:46:44.241117819 +0100
 Birth: 2022-12-04 16:39:19.649083657 +0100
```

Notes:

- Size and Blocks have increased as expected.
- Times of Access, Modify and Change have updated as expected.
- Type has changed to regular file.
- Links remain at 1.
- Inode # is 39683408 this is unchanged as expected, since it is a unique number for this file.

## Creating directories

Here I will make a new empty directory called "power-calculation" and monitor the stat information:

```zsh
~ ❯ mkdir power-calculation
~ ❯ gstat power-calculation
  File: power-calculation
  Size: 64              Blocks: 0          IO Block: 4096   directory
Device: 1,17    Inode: 39708257    Links: 2
Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 18:27:51.869496464 +0100
Modify: 2022-12-04 18:27:51.869496464 +0100
Change: 2022-12-04 18:27:51.869496464 +0100
 Birth: 2022-12-04 18:27:51.869496464 +0100
 ```

Notes:

- There are 2 Links in this empty directory. According to [this post](https://unix.stackexchange.com/questions/101515/why-does-a-new-directory-have-a-hard-link-count-of-2-before-anything-is-added-to), this represents the `.` and `..` entries created in every directory, we can see them with `ls -a`:

   ```zsh
   ~ ❯ cd power-calculation 
   ~/power-calculation ❯ ls -a
   .  ..
   ```

- `.` is pointing to the directory itself
  
- `..` is pointing to the parent directory

- This makes it easy to move around the file system e.g. using `cd ..` will move you up to parent directory.

## Creating nested directories

Here I am making a nested directory with the `-p` flag which will create the parent directories if they do not already exsist, and brace expansion, which will create the subdirectories.

```zsh
~ ❯ mkdir -p ngs/single-cell/{atac-seq,cite-seq,rna-seq/{processed,raw}}  
```

The result has a structure like this:

```zsh
ngs
 ┗ single-cell
 ┃ ┣ atac-seq
 ┃ ┣ cite-seq
 ┃ ┗ rna-seq
 ┃ ┃ ┣ processed
 ┃ ┃ ┗ raw
```

Notes:

- Every directory will have 2+n hard links, n being the number of subdirectories. Therefore, the new directories have the following number of links:
  
  ```zsh
  ngs (3 links)
  ┗ single-cell (5 links)
  ┃ ┣ atac-seq (2 links)
  ┃ ┣ cite-seq (2 links)
  ┃ ┗ rna-seq (4 links)
  ┃ ┃ ┣ processed (2 links)
  ┃ ┃ ┗ raw (2 links)
  ```

- It seems as if inode numbers are sequential based on their order of creation, which I designated with `mkdir -p ngs/single-cell/{atac-seq,cite-seq,rna-seq/{processed,raw}}`.
  ```zsh
  ngs (39709704)
  ┗ single-cell (39709705)
  ┃ ┣ atac-seq (39709706)
  ┃ ┣ cite-seq (39709707)
  ┃ ┗ rna-seq (39709708)
  ┃ ┃ ┣ processed (39709709)
  ┃ ┃ ┗ raw (39709710)
  ```

- Confirmed this by using `gstat` on every dir:

  ```zsh
  ~ ❯ gstat ngs
    File: ngs
    Size: 96              Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709704    Links: 3
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.133645989 +0100
  Modify: 2022-12-04 19:20:15.134637833 +0100
  Change: 2022-12-04 19:20:15.134637833 +0100
  Birth: 2022-12-04 19:20:15.133645989 +0100
  ~ ❯ gstat ngs/single-cell
    File: ngs/single-cell
    Size: 160             Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709705    Links: 5
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134632000 +0100
  Modify: 2022-12-04 19:20:15.134763460 +0100
  Change: 2022-12-04 19:20:15.134763460 +0100
  Birth: 2022-12-04 19:20:15.134632000 +0100
  ~ ❯ gstat ngs/single-cell/atac-seq
    File: ngs/single-cell/atac-seq
    Size: 64              Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709706    Links: 2
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134673667 +0100
  Modify: 2022-12-04 19:20:15.134673667 +0100
  Change: 2022-12-04 19:20:15.134673667 +0100
  Birth: 2022-12-04 19:20:15.134673667 +0100
  ~ ❯ gstat ngs/single-cell/cite-seq
    File: ngs/single-cell/cite-seq
    Size: 64              Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709707    Links: 2
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134714917 +0100
  Modify: 2022-12-04 19:20:15.134714917 +0100
  Change: 2022-12-04 19:20:15.134714917 +0100
  Birth: 2022-12-04 19:20:15.134714917 +0100
  ~ ❯ gstat ngs/single-cell/rna-seq 
    File: ngs/single-cell/rna-seq
    Size: 128             Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709708    Links: 4
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134757668 +0100
  Modify: 2022-12-04 19:20:15.134840169 +0100
  Change: 2022-12-04 19:20:15.134840169 +0100
  Birth: 2022-12-04 19:20:15.134757668 +0100
  ~ ❯ gstat ngs/single-cell/rna-seq/processed
    File: ngs/single-cell/rna-seq/processed
    Size: 64              Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709709    Links: 2
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134790668 +0100
  Modify: 2022-12-04 19:20:15.134790668 +0100
  Change: 2022-12-04 19:20:15.134790668 +0100
  Birth: 2022-12-04 19:20:15.134790668 +0100
  ~ ❯ gstat ngs/single-cell/rna-seq/raw      
    File: ngs/single-cell/rna-seq/raw
    Size: 64              Blocks: 0          IO Block: 4096   directory
  Device: 1,17    Inode: 39709710    Links: 2
  Access: (0755/drwxr-xr-x)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
  Access: 2022-12-04 19:20:15.134836044 +0100
  Modify: 2022-12-04 19:20:15.134836044 +0100
  Change: 2022-12-04 19:20:15.134836044 +0100
  Birth: 2022-12-04 19:20:15.134836044 +0100
  ```

## Targeting and linking files with the inode number

We can find files with their inode numbers using the `gfind` command. For example I will make a new file called `project1-metadata.txt` in the `ngs/single-cell/rna-seq` directory and display its stat info.

```zsh
~/ngs ❯ touch single-cell/rna-seq/project1-metadata.txt
~/ngs ❯ gstat single-cell/rna-seq/project1-metadata.txt
  File: single-cell/rna-seq/project1-metadata.txt
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 1,17    Inode: 39715106    Links: 1
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 21:13:45.878783699 +0100
Modify: 2022-12-04 21:13:45.878783699 +0100
Change: 2022-12-04 21:13:45.878783699 +0100
 Birth: 2022-12-04 21:13:45.878783699 +0100
```

You could search for the file with just its inode number, and find its location (presuming you have access):

```zsh
~/ngs ❯ gfind -inum 39715106
./single-cell/rna-seq/project1-metadata.txt
```

You can create a hard link to `project1-metadata.txt` using the `gln` (`ln`, "Link") command, here I create a new filename that points exactly to the same data as `project1-metadata.txt`:

```zsh
~/ngs ❯ gln single-cell/rna-seq/project1-metadata.txt single-cell/rna-seq/project1-metadata-hardlink.txt
```

Now both files share the same inode number and have 2 links.
```zsh
~/ngs ❯ gstat single-cell/rna-seq/project1-metadata-hardlink.txt
  File: single-cell/rna-seq/project1-metadata-hardlink.txt
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 1,17    Inode: 39715106    Links: 2
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 21:13:45.878783699 +0100
Modify: 2022-12-04 21:13:45.878783699 +0100
Change: 2022-12-04 21:17:12.568744625 +0100
 Birth: 2022-12-04 21:13:45.878783699 +0100
 ~/ngs ❯ gstat single-cell/rna-seq/project1-metadata.txt         
  File: single-cell/rna-seq/project1-metadata.txt
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 1,17    Inode: 39715106    Links: 2
Access: (0644/-rw-r--r--)  Uid: (  501/danieljgorski)   Gid: (   20/   staff)
Access: 2022-12-04 21:13:45.878783699 +0100
Modify: 2022-12-04 21:13:45.878783699 +0100
Change: 2022-12-04 21:17:12.568744625 +0100
 Birth: 2022-12-04 21:13:45.878783699 +0100
```

If we search again using the inode number, both files are returned:

```zsh
~/ngs ❯ gfind -inum 39715106
./single-cell/rna-seq/project1-metadata.txt
./single-cell/rna-seq/project1-metadata-hardlink.txt
```

If changes are made to one file, they are reflected in the linked file:

```zsh
~/ngs ❯ echo "1000 cells, 4-Dec-2022, 10xChromium" > single-cell/rna-seq/project1-metadata.txt
~/ngs ❯ cat single-cell/rna-seq/project1-metadata-hardlink.txt
1000 cells, 4-Dec-2022, 10xChromium
```

Even if the original file is moved and edited, the changes will be reflected in the hard linked file. Here I move the original metadata file from the rna-seq/ folder to the atac-seq/ folder:

```zsh
~/ngs ❯ mv single-cell/rna-seq/project1-metadata.txt single-cell/atac-seq 
```

Edit it further:

```zsh
~/ngs ❯ echo "processed with newest pipeline" >> single-cell/atac-seq/project1-metadata.txt 
```

Then display the changes by `cat` of the hard linked file:

```zsh
~/ngs ❯ cat single-cell/rna-seq/project1-metadata-hardlink.txt 
1000 cells, 4-Dec-2022, 10xChromium
processed with newest pipeline
```

## Useful commands

I imagine then, in practice, the combination of `gstat`, `gfind` and `gln` are very useful for seeing if a file of interest has associated linked files. Then using its inode number, you could find any linked file easily. Perhaps creating linked files that point to the same data (via hard links or symbolic links) could be also useful for multiple people who need access to the same data, and would like their reference to be updated as the original data is updated/moved.
