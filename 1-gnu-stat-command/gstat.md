# GNU core utilities on macOS

## Prompt

*Unix/Linux systems often come with the gnu stat command. It is useful for viewing systems-level information about a directory or file. On macs the stat command is not quite as useful and you might want to install the gnu stat command with the g prefix (gnu stat becomes gstat, leaving the original mac version of stat command intact).*

*See this stack overflow tip for more information:
<https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities>*

*Create files, directories, and nested directories and monitor the stat information. Also pay attention to the inode information. Can you explain how “Links” increments and decrements for directories and files? What command can you use to target a file via inode number? What are the Links in an empty directory? How do stat links relate to the ln function? While investigating this system, what were the most useful/informative commands? Document all your discoveries, experiments including commands and their results in a markdown document and submit to a public github account. We are interested in how deeply you investigate, how organized and thorough your notes are.*

## Installing GNU core utilities

### Installation

Installing GNU core utilites with the g prefix using `homebrew` as indicated from the apple stackexhange posting. As mentioned in the prompt, as well as the dicussions on stackexchange, I believe keeping the g-prefix is a good idea, therefore I won't modify my `PATH` to use the commands without the prefix.

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

### Overview

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
- Type - Type of file system
- Fundamental block size - The size of each block in the file system.
- Blocks:
  - Total - Number of total blocks in the file system
  - Free - Number of free blocks
  - Available - Number of free blocks availble to non-root users
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

Some observations:

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

Some observations:

- Size and Blocks have increased as expected.
- Times of Access, Modify and Change have updated as expected.
- Type has changed to regular file.
- Links remain at 1.
- Inode # is 39683408 this is unchanged as expected, since it is a unique number for this file.

## Creating directories

Monitor stat information, pay attention to inode

## Creating nested directories

Monitor stat information, pay attention to inode

## Explanation of "Links"

## Targeting files with inode

## What are the links in an empty directory?

## How do stat links relate to the ln function?

## What are the most useful/informative commands
