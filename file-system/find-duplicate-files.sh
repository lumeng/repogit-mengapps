#!/usr/bin/env bash

## Summary: find duplicate files
## Meng Lu <lumeng.dev@gmail.com>


DIR=${1:-`pwd`}

FILENAME=`basename $0`

TMPFILE=`mktemp /tmp/${FILENAME}.XXXXXX` || exit 1

find -P $DIR -type f -exec cksum {} \; | sort | tee $TMPFILE | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILE | sort -nr -t' ' -k2,2 | cut -f 3- -d ' ' | while read line; do ls -lhta "$line"; done

