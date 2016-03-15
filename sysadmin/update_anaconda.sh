#!/usr/bin/env bash

## Save old $PATH and restore it later
OLD_PATH="$PATH"

## Get the path of binaries installed via Homebrew.
if [[ $(uname) == 'Linux' ]]; then
    ANACONDA_BIN_PATH=$HOME/anaconda2/bin
elif [[ $(uname) == 'Darwin' ]]; then
    ANACONDA_BIN_PATH=$HOME/anaconda/bin
else
    echo >&2 "Anaconda installation path is not determined on $(uname)."
	exit 1
fi

##
#+ Prepend Anaconda binary path to $PATH, so when installing of compiling
#+ softwares using conda, it sees softwares and libraries installed by
#+ conda first.
##
export PATH=$ANACONDA_BIN_PATH:$PATH

## If brew is not installed, exit.
type conda >/dev/null 2>&1 || { echo >&2 "Anaconda is not installed. Aborting."; exit 1; }

conda update conda
conda update anaconda

## Restore $PATH.
export PATH=$OLD_PATH

## END
