#!/usr/bin/env bash

## Summary: find largest files recursively

TIMESTANP=`time +%s`
OUTPUTFILE="/tmp/list_of_large_files__$TIMESTAMP.txt"

find -P -O2 . -type f -size +100M -user $USER -exec ls -sh '{}' >> $OUTPUTFILE \;

## A different method
#du -h | awk '{printf "%s %08.2f\t%s\n", index("KMG", substr($1, length($1))), substr($1, 0, length($1)-1), $0}'

## EOF