#!/usr/bin/env bash

##
#+ Script for updating LaTeX and packages.
#+
##

## Save old $PATH and restore it later
OLD_PATH="$PATH"

## The most basic paths that should be included in $PATH
BASIC_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin:/usr/local/bin

##
#+ Prepend Homebrew binary path to $PATH, so when installing of compiling
#+ softwares using brew, it sees softwares and libraries installed by
#+ brew first.
##

export PATH=/Library/TeX/texbin/:${BASIC_PATH}

export TEXMFHOME=$(kpsewhich -var-value=TEXMFHOME)

if [[ ! -d $TEXMFHOME ]]; then
	mkdir $TEXMFHOME
fi

##
#+ Update 
#+
#+

#+ References:
#+ *

sudo tlmgr update --self

sudo tlmgr backup --all --clean

sudo tlmgr update --all

sudo tlmgr backup --all --clean=0

################################################################################
#+ Install softwares.
##

## 2017-7-17： Install shading package.
curl --create-dirs -o $TEXMFHOME/shading.sty http://ctan.mirrors.hoobly.com/macros/latex209/contrib/shading/shading.sty

curl --create-dirs -o $TEXMFHOME/shading.tex http://ctan.mirrors.hoobly.com/macros/latex209/contrib/shading/shading.tex

#tlmgr install shading


## more ...


## Restore $PATH.
export PATH=$OLD_PATH

## END
