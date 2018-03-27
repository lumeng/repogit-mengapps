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

find -P "${DIR}" -type f -exec cksum '{}' \; `# find all files and calculate checksum` \
    | sort `# sort by checksum, size, file name` \
	| tee ${TMPFILEDATA} `# output the data into file and stdout` \
	| cut -f 1-2 -d ' ' `# take the checksum and size which will be used as keys` \
	| uniq -d > ${TMPFILEDUPKEYS} # find keys for duplicated files


grep -if ${TMPFILEDUPKEYS} ${TMPFILEDATA} `# find duplicated files ` \
	| sort -nr -t' ' -k2,2 `# sort by file sizes` \
	| cut -f 3- -d ' ' `# leave only file names` \
	| while read line; do ls -lta "$line"; done > ${TMPFILELOG} # get more detailed info about files

echo "List of duplicate files created: ${TMPFILELOG}"

## END
