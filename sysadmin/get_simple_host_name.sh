#!/usr/bin/env bash

###############################################################################
#+ Summary: a Bash script to get "simple" host name.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
##

REGEX='(.*)\.local'

SIMPLE_HOST_NAME="$(hostname)"

# echo "[DEBUG] ${SIMPLE_HOST_NAME}"

HOST_NAME_REGEX='(.*)\.local'

if [[ "${SIMPLE_HOST_NAME}" =~ ${HOST_NAME_REGEX} ]]; then
    #echo "[DEBUG] matched!"
    echo "${BASH_REMATCH[1]}"
else
	:
    #echo "[DEBUG] does not match!"	
fi

## END
