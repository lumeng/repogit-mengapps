#!/usr/bin/env bash

##
#+ Script for updating Python.
#+
##

## If brew is not installed, exit.
if [[ $(uname) == 'Darwin' ]]; then
	type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }
fi

##############################################################################
#+ Update Homebrew
##
if [[ -f ./update_homebrew.sh ]]; then
    source ./update_homebrew.sh
else
    echo "Cannot find script ./update_homebrew.sh. Please update Homebrew first."
	exit 1
fi

################################################################################
#+ Install Python.
##

## 2017-7-20： Install Python.
if [[ $(uname) == 'Darwin' ]]; then
	type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }
	brew list python > /dev/null || { echo >&2 "Python is not installed via Homebrew. Aborting."; exit 1; }

fi

################################################################################
#+ Install python packages.
##

## On macOS, use /usr/local/bin
if [[ $(uname) == 'Darwin' && -d '/usr/local/bin' ]]; then
    export PATH="/usr/local/bin:$PATH"  ## Make sure brew is on the path before checking its existence.
fi

if [[ $(uname) == 'Darwin' && -d '/usr/local/opt/python/libexec/bin' ]]; then
	export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

## Update pip and setuptools
pip2 install --upgrade pip setuptools
pip3 install --upgrade pip setuptools

##############################################################################
#+ Restore $PATH.
##
export PATH=$OLD_PATH

## END
