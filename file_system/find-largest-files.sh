#!/usr/bin/env bash

## Summary: find largest files recursively

TMPSUBDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename 0).XXXXXXXXXXXX")

TIMESTAMP="$(date +%s)"
OUTPUTFILE="${TMPSUBDIR}/list_of_large_files__${TIMESTAMP}.txt"
touch $OUTPUTFILE

find -P -O2 . -type f -size +500M -user $USER -exec ls -s '{}' \; | \
    sort -nr -t' ' -k1,1 >> $OUTPUTFILE

echo ${OUTPUTFILE}

cat ${OUTPUTFILE}

## EOF
