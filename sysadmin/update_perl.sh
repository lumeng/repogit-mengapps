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
#+ Install and update cpan.
##
brew list cpanminus >/dev/null || brew install cpanminus
brew list cpanminus >/dev/null && brew upgrade cpanminus

################################################################################
#+ Install perlbrew.
#+ Reference: https://perlbrew.pl/
##

sudo cpan App::perlbrew
perlbrew init

% perlbrew install perl-5.26.0
% perlbrew switch perl-5.26.0

perlbrew install perl-blead
perlbrew use perl-blead

% perlbrew help


################################################################################
#+ Install softwares.
##

#+ 2017-7-19: install packages required by git-mediawiki
#+ Reference: https://github.com/Git-Mediawiki/Git-Mediawiki/wiki/User-manual
sudo cpan MediaWiki::API
sudo cpan DateTime::Format::ISO8601
sudo cpan LWP::Protocol::https

## Restore $PATH.
export PATH=$OLD_PATH

## END
