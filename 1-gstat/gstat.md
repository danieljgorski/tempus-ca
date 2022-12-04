## Prompt
Unix/Linux systems often come with the gnu stat command. It is useful for viewing systems-level information about a directory or file. On macs the stat command is not quite as useful and you might want to install the gnu stat command with the g prefix (gnu stat becomes gstat, leaving the original mac version of stat command intact).  

See this stack overflow tip for more information:
https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities

Create files, directories, and nested directories and monitor the stat information. Also pay attention to the inode information. Can you explain how “Links” increments and decrements for directories and files? What command can you use to target a file via inode number? What are the Links in an empty directory? How do stat links relate to the ln function? While investigating this system, what were the most useful/informative commands? Document all your discoveries, experiments including commands and their results in a markdown document and submit to a public github account. We are interested in how deeply you investigate, how organized and thorough your notes are.


## Installing gnu stat command on macos

```console
brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
```


## Creating files
Monitor stat information, pay attention to inode

## Creating directories
Monitor stat information, pay attention to inode

## Creating nested directories
Monitor stat information, pay attention to inode

## Explanation of "Links"

## Targeting files with inode

## What are the links in an empty directory?

## How do stat links relate to the ln function?

## What are the most useful/informative commands