#!/usr/bin/env bash

##
#+ Script for updating Homebrew.
#+
##

## Abort if not on Mac OS X.
if [[ ! $(uname) == 'Darwin' ]]; then
    echo >&2 "Since Homebrew is a package management system for macOS (formerly known as Mac OS X), it does not make sense to update it on $(uname). Abort."
	exit 1
fi


## If brew is not installed, exit.
export PATH=/usr/local/bin:$PATH  ## Make sure brew is on the path before checking its existence.
type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }


## Save old $PATH and restore it later
OLD_PATH="$PATH"

## Get the path of binaries installed via Homebrew.
BREW_BIN_PATH=$(brew --prefix)/bin

## The most basic paths that should be included in $PATH
BASIC_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin

##
#+ Prepend Homebrew binary path to $PATH, so when installing of compiling
#+ softwares using brew, it sees softwares and libraries installed by
#+ brew first.
##

export PATH=$BREW_BIN_PATH:$BASIC_PATH

##
#+ Update 
#+
#+

#+ References:
#+ * http://apple.stackexchange.com/questions/277386/how-to-upgrade-homebrew-itself-not-softwares-formulas-installed-by-it-on-macos
#+ * http://discourse.brew.sh/t/how-to-upgrade-brew-stuck-on-0-9-9/33

cd "$(brew --repo)" && git fetch && git reset --hard origin/master && git clean -i


#+ Update, upgrade, cleanup, diagnose
brew update
brew upgrade
brew prune
brew cleanup
brew doctor

################################################################################
#+ Install softwares.
##

## 2017-5-21: for using Multimarkdown syntax in source files of Ikiwiki websites.
brew list multimarkdown >/dev/null || brew install multimarkdown

## 2017-5-21: Install FileZilla via Homebrew so it's automatically updated via the cron job to update Homebrew.
brew cask list filezilla >/dev/null || brew cask install filezilla


## more ...



##
#+ Fix permissions required by applications installed via Munki 
#+ See http://apple.stackexchange.com/questions/174492/how-to-uninstall-munki-managed-software-center-app/
#+ 
#+ * As of at least Homebrew 1.1.11 (March, 2017) (what's the earliest?), Homebrew
#+ no longer requires /usr/local/ to have an ownership different from the
#+ default value of root:wheel. At some point, when running 'brew upgrade' it
#+ tells that
#+     Homebrew no longer needs to have ownership of /usr/local. If you wish you can
#+     return /usr/local to its default ownership with:
#+     sudo chown root:wheel /usr/local
##
#if [[ -d /usr/local/munki ]]; then
#   sudo chown -R root:wheel /usr/local/munki
#   sudo chmod -R o-w /usr/local/munki
#fi

## Restore $PATH.
export PATH=$OLD_PATH

## END
