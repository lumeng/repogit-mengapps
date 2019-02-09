#!/usr/bin/env bash

( type rsync >/dev/null 2>&1 && \
    type dirname >/dev/null 2>&1 && \
    type basename >/dev/null 2>&1 ) || \
    { echo "rsync is not installed!"; exit 1; }

if [[ $# -ge 1 && -e $1 ]]; then
    SRC=$1
else
    echo "[ERROR] No source file or directory provided! Usage: $0 <file or directory to back up>"
    exit 1
fi

if [[ $# -ge 2 ]]; then
    BACKUP=$2
else
    if [[ -d "${SRC}" ]]; then
        BACKUP="$(dirname $SRC)/$(basename $SRC).bak"
    elif [[ -f "${SRC}" ]]; then
	BACKUP="$(dirname $SRC)/$(basename $SRC).bak"
    else
	echo "[ERROR] ${SRC} is not a normal file or directory! Abort."
	exit 1
    fi
fi

if [[ -e "${BACKUP}" ]]; then
    echo "[ERROR] The backup directory ${BACKUP} already exists! Abort."
    exit 1
fi

if [[ -d "${SRC}" ]]; then
    rsync -zhavib "${SRC}/" "${BACKUP}"
else
    rsync -zhavib "${SRC}" "${BACKUP}"
fi

# END
