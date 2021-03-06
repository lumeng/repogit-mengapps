#!/usr/bin/env bash

## Summary: find duplicate files
## Meng Lu <lumeng.dev@gmail.com>

## To-do
## * sort result by change times, older first
## * multiple directories
##


DIR=${1:-`pwd`} ## use provided path if available, otherwise the current path

FILENAME=`basename $0`

TMPFILE=`mktemp /tmp/${FILENAME}.XXXXXX` || exit 1

## one-line version
#find -P . -type f -exec cksum {} \; | sort | tee $TMPFILE | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | sort -nr -t' ' -k2,2 | cut -f 3- -d ' ' | while read line; do ls -lhta "$line"; done

## multi-line version with comments
find -P $DIR -type f -exec cksum {} \; | # find non-directory files and compute their checksum; -P: never follow symbolic links
sort | # sort by {checksum, file size, file name}
tee $TMPFILE | # save a copy in a temporary file and pass along
cut -f 1-2 -d ' ' | # keep only the checksum and file size
uniq -d | # remove uniq ones
grep -if - $TMPFILE | # greps from previously saved file list the lines of duplicate files identified by having same file size and checksum; - is from redirecting stdout to stdin
sort -nr -t' ' -k2,2 | # sort by descending file size
cut -f 3- -d ' ' | # keep only file name
while read line; do ls -lhta "$line"; done # do informative ls on all found duplicate files


## Some previous problematic implementations
#find . \! -type d -exec cksum {} \; | sort | tee $TMPFILE | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | cut -f 3- -d ' ' | while read line; do ls -lhtaSr "$line"; done
#find . \! -type d -exec cksum {} \; | sort | tee $TMPFILE | cut c 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | awk '{print $3}'
#find . \! -type d -exec cksum {} \; | sort | tee $TMPFILE | uniq -d | grep -if - $TMPFILE | awk '{print $1 $2 $3}'

