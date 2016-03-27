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


## The most basic paths that should be included in $PATH
if [[ $(uname) == 'Linux' ]]; then
    BASIC_PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/games
elif [[ $(uname) == 'Darwin' ]]; then
    BASIC_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin
else
    echo >&2 "Behavior on OSs other than Mac OS X and Ubuntu Linux is not assured."
	BASIC_PATH=$PATH
fi



##
#+ Prepend Anaconda binary path to $PATH, so when installing of compiling
#+ softwares using conda, it sees softwares and libraries installed by
#+ conda first.
##
export PATH=$ANACONDA_BIN_PATH:$BASIC_PATH

## If brew is not installed, exit.
type conda >/dev/null 2>&1 || { echo >&2 "Anaconda is not installed. Aborting."; exit 1; }

conda update conda >/dev/null 2>&1
conda update anaconda >/dev/null 2>&1

## Restore $PATH.
export PATH=$OLD_PATH

## END
