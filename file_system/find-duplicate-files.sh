#!/usr/bin/env bash

## Summary: find duplicate files
## Meng Lu <lumeng.dev@gmail.com>

## If gmktemp exists, use it instead of mktemp
{ type gmktemp >/dev/null 2>&1 && MKTEMP_BIN=gmktemp ; } || \
	{ type mktemp >/dev/null 2>&1 && MKTEMP_BIN=mktemp ; } || \
	{ echo >&2 "Please install gmktemp and/or mktemp. Aborting."; exit 1; }

DIR=${1:-`pwd`}

FILENAME=`basename $0`

TMPDIR="/tmp"

DATETIME=`date +%Y%m%d%H%M%S`

TMPFILEDATA=`$MKTEMP_BIN ${TMPDIR}/XXXXX_${FILENAME}_${DATETIME}` || exit 1

TMPFILEDUPKEYS=`$MKTEMP_BIN ${TMPDIR}/XXXXX_${FILENAME}_${DATETIME}.dupkeys` || exit 1

TMPFILELOG=`$MKTEMP_BIN ${TMPDIR}/XXXXX_${FILENAME}_${DATETIME}.log` || exit 1

## TODO: how to put everything into oneline?
#find -P $DIR -type f -exec cksum '{}' \; | sort | tee $TMPFILEDATA | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILEDATA | sort -nr -t' ' -k2,2 | cut -f 3- -d ' ' | while read line; do ls -lhta "$line"; done

find -P $DIR -type f -exec cksum '{}' \; `# find all files and calculate checksum` \
    | sort `# sort by checksum, size, file name` \
	| tee ${TMPFILEDATA} `# output the data into file and stdout` \
	| cut -f 1-2 -d ' ' `# take the checksum and size which will be used as keys` \
	| uniq -d > ${TMPFILEDUPKEYS} # find keys for duplicated files

grep -if ${TMPFILEDUPKEYS} ${TMPFILEDATA} `# find duplicated files ` \
	| sort -nr -t' ' -k2,2 `# sort by file sizes` \
	| cut -f 3- -d ' ' `# leave only file names` \
	| while read line; do ls -lhta "$line"; done > ${TMPFILELOG} # get more detailed info about files

echo "Log file created: ${TMPFILELOG}"
echo "Done!"


### Old implementation needing to clean up
# ## To-do
# ## * sort result by change times, older first
# ## * multiple directories
# ##
# 
# 
# DIR=${1:-`pwd`} ## use provided path if available, otherwise the current path
# 
# FILENAME=`basename $0`
# 
# TMPFILE=`$MKTEMP_BIN /tmp/${FILENAME}.XXXXXX` || exit 1
# 
# ## one-line version
# #find -P . -type f -exec cksum '{}' \; | sort | tee $TMPFILE | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | sort -nr -t' ' -k2,2 | cut -f 3- -d ' ' | while read line; do ls -lhta "$line"; done
# 
# ## multi-line version with comments
# find -P $DIR -type f -exec cksum '{}' \; | # find non-directory files and compute their checksum; -P: never follow symbolic links
# sort | # sort by {checksum, file size, file name}
# tee $TMPFILE | # save a copy in a temporary file and pass along
# cut -f 1-2 -d ' ' | # keep only the checksum and file size
# uniq -d | # remove uniq ones
# grep -if - $TMPFILE | # greps from previously saved file list the lines of duplicate files identified by having same file size and checksum; - is from redirecting stdout to stdin
# sort -nr -t' ' -k2,2 | # sort by descending file size
# cut -f 3- -d ' ' | # keep only file name
# while read line; do ls -lhta "$line"; done # do informative ls on all found duplicate files
# 
# 
# ## Some previous problematic implementations
# #find . \! -type d -exec cksum '{}' \; | sort | tee $TMPFILE | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | cut -f 3- -d ' ' | while read line; do ls -lhtaSr "$line"; done
# #find . \! -type d -exec cksum '{}' \; | sort | tee $TMPFILE | cut c 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | awk '{print $3}'
# #find . \! -type d -exec cksum '{}' \; | sort | tee $TMPFILE | uniq -d | grep -if - $TMPFILE | awk '{print $1 $2 $3}'
# 


## END

