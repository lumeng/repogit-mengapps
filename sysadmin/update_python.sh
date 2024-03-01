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
    read -n1 -p "Update Homebrew packages first 1) update_homebrew.sh; 2) update_homebrew_no_install.sh; 3) no update? [1, 2, 3]" doit
    case $doit in
       1) source ./update_homebrew.sh ;;
       2) source ./update_homebrew_no_install.sh ;;
       *) echo "Skipping updating Homebrew.\n" ;;
    esac
else
    echo "[ERROR] Cannot find script ./update_homebrew.sh. Please update Homebrew first.\n"
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
pip install --upgrade pip
pip3 install --upgrade pip

pip install --upgrade setuptools
pip3 install --upgrade setuptools

## * 2017-7-21: Install and upgrade virtualenv.
#+ * 2020-7-20: Stop installing virtualenv for Python 3.8 as it is superseded
#+   by venv. 
#+
##
pip install --upgrade virtualenv
## pip3 install --upgrade virtualenv

pip install --upgrade virtualenvwrapper
pip3 install --upgrade virtualenvwrapper

## 2017-9-7: Install and upgrade matplotlib, pandas, scikit-learn, nltk, mrjob
pip install --upgrade matplotlib
pip3 install --upgrade matplotlib

pip install --upgrade pandas
pip3 install --upgrade pandas

pip install --upgrade scikit-learn
pip3 install --upgrade scikit-learn

pip install --upgrade nltk
pip3 install --upgrade nltk

pip install --upgrade mrjob
pip3 install --upgrade mrjob


## 2017-9-16: Install and upgrade pyzmq
#+ * pyzmq is required for the Python executable to be registered in Wolfram
#+ Language as an external evalutor using RegisterExternalEvaluator[<>]
##
pip install --upgrade pyzmq
pip3 install --upgrade pyzmq


## 2017-11-19: Install and upgrade JypyterLab
##
pip install --upgrade jupyterlab
pip3 install --upgrade jupyterlab


## 2018-1-8: [Install and upgrade TensorFlow](https://www.tensorflow.org/install/install_mac)
##
pip install --upgrade tensorflow
pip3 install --upgrade tensorflow


##############################################################################
#+ Restore $PATH.
##
export PATH=$OLD_PATH

## END
