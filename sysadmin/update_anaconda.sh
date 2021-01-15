#!/usr/bin/env bash
###############################################################################
#+ * Update Anaconda
#+
#+ * References
#+ - https://docs.anaconda.com/anaconda/install/
## 

## Save old $PATH and restore it later
OLD_PATH="$PATH"
OLD_MANPATH="$MANPATH"

## Get the path of binaries installed via Homebrew.
if [[ $(uname) == 'Linux' ]]; then
    ANACONDA_PATH=$HOME/anaconda2/bin
    ANACONDA_MANPATH=$HOME/anaconda2/share/man
elif [[ $(uname) == 'Darwin' ]]; then
    ANACONDA_PATH=$HOME/anaconda/bin
    ANACONDA_MANPATH=$HOME/anaconda/share/man
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
export PATH=$ANACONDA_PATH:$BASIC_PATH
export MANPATH=$ANACONDA_MANPATH:$MANPATH

## If brew is not installed, exit.
type conda >/dev/null 2>&1 || { echo >&2 "Anaconda is not installed. Aborting."; exit 1; }

conda clean --lock
conda update conda
conda update anaconda

## Restore $PATH.
export PATH=$OLD_PATH
export MANPATH=$OLD_MANPATH

## END
