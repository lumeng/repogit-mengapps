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
pip2 install --upgrade pip
pip3 install --upgrade pip

pip2 install --upgrade setuptools
pip3 install --upgrade setuptools

## 2017-7-21: Install and upgrade virtualenv.
pip2 install --upgrade virtualenv
pip3 install --upgrade virtualenv

pip2 install --upgrade virtualenvwrapper
pip3 install --upgrade virtualenvwrapper

## 2017-9-7: Install and upgrade matplotlib, pandas, scikit-learn, nltk, mrjob
pip2 install --upgrade matplotlib
pip3 install --upgrade matplotlib

pip2 install --upgrade pandas
pip3 install --upgrade pandas

pip2 install --upgrade scikit-learn
pip3 install --upgrade scikit-learn

pip2 install --upgrade nltk
pip3 install --upgrade nltk

pip2 install --upgrade mrjob
pip3 install --upgrade mrjob


## 2017-9-16: Install and upgrade pyzmq
#+ * pyzmq is required for the Python executable to be registered in Wolfram
#+ Language as an external evalutor using RegisterExternalEvaluator[<>]
##
pip2 install --upgrade pyzmq
pip3 install --upgrade pyzmq


## 2017-11-19: Install and upgrade JypyterLab
##
pip2 install --upgrade jupyterlab
pip3 install --upgrade jupyterlab


##############################################################################
#+ Restore $PATH.
##
export PATH=$OLD_PATH

## END
