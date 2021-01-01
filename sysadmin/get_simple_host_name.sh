#!/usr/bin/env bash

###############################################################################
#+ Summary: a Bash script to get "simple" host name.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
##

HOST_NAME_REGEX='(.*)(\.local|\.lan)'

SIMPLE_HOST_NAME="$(hostname)"

echo "[DEBUG] ${SIMPLE_HOST_NAME}"

if [[ "${SIMPLE_HOST_NAME}" =~ ${HOST_NAME_REGEX} ]]; then
#    echo "[DEBUG] matched!"
#    echo "[DEBUG] ${BASH_REMATCH[1]}"
    export meng_HOST_NAME="${BASH_REMATCH[1]}"
else
#    echo "[DEBUG] does not match!"	
    export meng_HOST_NAME="${SIMPLE_HOST_NAME}"
fi

# echo "[DEBUG] $meng_HOST_NAME"

## END
