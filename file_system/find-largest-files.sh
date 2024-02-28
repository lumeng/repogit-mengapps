#!/usr/bin/env bash

## Summary: find largest files recursively

TMPSUBDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename 0).XXXXXXXXXXXX")

TIMESTAMP="$(date +%s)"
OUTPUTFILE="${TMPSUBDIR}/list_of_large_files__${TIMESTAMP}.txt"
touch $OUTPUTFILE

if [[ $(uname) == 'Darwin' ]]; then
    type gfind >/dev/null 2>&1 || { echo >&2 "gfind is not installed. Aborting."; exit 1; }
fi

if [[ $(uname) == 'Darwin' ]]; then
    FIND_CMD=gfind
else
    FIND_CMD=find
fi


$FIND_CMD -P -O2 . -type f -size +1000M -user $USER -exec ls -pks '{}' \; | \
    sort -nr -t' ' -k1,1 >> $OUTPUTFILE

echo ${OUTPUTFILE}

cat ${OUTPUTFILE}

## EOF
