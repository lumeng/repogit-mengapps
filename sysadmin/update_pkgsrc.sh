#!/usr/bin/env bash

##
#+ Script for updating pkgsrc.
#+
#+ References:
#+ * https://pkgsrc.joyent.com/install-on-osx/
##

## Abort if not on macOS.
if [[ ! $(uname) == 'Darwin' ]]; then
    echo >&2 "Since pkgsrc is a package management system for macOS (formerly known as Mac OS X), it does not make sense to update it on $(uname). Abort."
	exit 1
fi


## If pkgsrc is not installed, exit.
export PATH=/opt/pkg/bin:$PATH  ## Make sure pkgsrc is on the path before checking its existence.
type pkgin >/dev/null 2>&1 || { echo >&2 "pkgsrc is probably not installed. Aborting."; exit 1; }


## Save old $PATH and restore it later
OLD_PATH="$PATH"

## Get the path of binaries installed via pkgsrc.
#BREW_BIN_PATH=$(brew --prefix)/bin
PKGSRC_BIN_PATH=/opt/pkg/bin

## The most basic paths that should be included in $PATH
BASIC_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin

##
#+ Prepend pkgsrc binary path to $PATH, so when installing of compiling
#+ softwares using brew, it sees softwares and libraries installed by
#+ brew first.
##

export PATH=$PKGSRC_BIN_PATH:$BASIC_PATH

##
#+ Update 
#+
#+

## Refresh the pkgin database with the latest version
sudo pkgin -y update

## Upgrade all out-of-date packages, this supersedes 'sudo pkgin -y upgrade'
sudo pkgin -y full-upgrade

## Automatically remove orphaned dependencies
sudo pkgin -y autoremove


## Install packages

## 201705 ikiwiki
sudo pkgin -y install ikiwiki
sudo pkgin -y install p5-PerlMagick

## 20170521: ikiwiki dependency (see https://ikiwiki.info/forum/How_to_install_Text:Multimarkdown__63__/)
#+ 2019-11-8: Install multimarkdown via homebrew instead.
#+ 2020-2-13: It is NOT recommended to turn on the multimarkdown features for
#+ Ikiwiki as the source files written in Multimarkdown syntax is less
#+ compatible with other Markdown systems, if they are ever used in other
#+ contexts.
#+ C.f. https://web.archive.org/web/20200213202056/https://ikiwiki.info/plugins/mdwn/
#+
##
# sudo pkgin -y install multimarkdown


## Restore $PATH.
export PATH=$OLD_PATH

## END
