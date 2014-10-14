#!/usr/bin/env bash

## Summary: find duplicate files
## Meng Lu <lumeng.dev@gmail.com>

DIR=${1:-`pwd`}

FILENAME=`basename $0`

DATETIME=`date +%Y%m%d%H%M%S`

TMPFILEDATA=`mktemp /tmp/${FILENAME}.${DATETIME}` || exit 1

TMPFILEDUPKEYS=`mktemp /tmp/${FILENAME}.${DATETIME}.dupkeys` || exit 1

TMPFILELOG=`mktemp /tmp/${FILENAME}.${DATETIME}.log` || exit 1

## TODO: how to put everything into oneline?
#find -P $DIR -type f -exec cksum {} \; | sort | tee $TMPFILEDATA | cut -f 1-2 -d ' ' | uniq -d | grep -if - $TMPFILEDATA | sort -nr -t' ' -k2,2 | cut -f 3- -d ' ' | while read line; do ls -lhta "$line"; done

find -P $DIR -type f -exec cksum {} \; `# find all files and calculate checksum` \
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
