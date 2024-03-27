#!/usr/bin/env bash

##
#+ Script for updating Homebrew.
#+
##

##############################################################################
## Abort if not on Mac OS X.
if [[ ! $(uname -s) == 'Darwin' ]]; then
    echo >&2 "Since Homebrew is a package management system for macOS (formerly known as Mac OS X), it does not make sense to update it on $(uname -s). Abort."
    exit 1
fi

xcode-select --install


##############################################################################
## If brew is not installed, exit.
export PATH=/usr/local/bin:$PATH  ## Make sure brew is on the path before checking its existence.
type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }


##############################################################################
#+ Prepare $PATH environment variable.
#+
##

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


##############################################################################
#+ Setting up find command.
#+
if [[ -f /usr/local/bin/gfind ]]; then
    FIND_BIN=/usr/local/bin/gfind
else
    type find >/dev/null 2>&1 && FIND_BIN=find
fi

type $FIND_BIN >/dev/null 2>&1 || ( echo "[ERROR] Install GNU find executable first!" && exit 1 )


################################################################################
#+ Update Homebrew Git repo.
#+
#+

#+ References:
#+ * http://apple.stackexchange.com/questions/277386/how-to-upgrade-homebrew-itself-not-softwares-formulas-installed-by-it-on-macos
#+ * http://discourse.brew.sh/t/how-to-upgrade-brew-stuck-on-0-9-9/33

if [[ -d "$(brew --prefix)/Homebrew" ]]; then
    echo "[DEBUG] Start checking and fixing owner, group, and perission of $(brew --prefix)/Homebrew ..."
    sudo chown -R $(id -un):wheel "$(brew --prefix)/Homebrew"
    sudo chmod -R u+rw $(brew --prefix)/Homebrew
    $FIND_BIN $(brew --prefix)/Homebrew -type d -exec sudo chmod ug+x '{}' \;
fi
cd "$(brew --repo)" && git fetch && git reset --hard origin/master && git clean -i


##############################################################################
#+ Temporarily pin a cask, i.e. pause the upgrading of a cask
#+
#+
brew tap buo/cask-upgrade    # install `brew-cask-upgrade`

#brew cu pin intellij-idea     # pin the cask you want
brew cu unpin intellij-idea

#+ Update, upgrade, cleanup, diagnose
brew update

brew upgrade

brew cleanup


##############################################################################
#+ Update all softwares installed using "brew cask" using 'brew-cask-upgrade'.
#+ * https://github.com/buo/homebrew-cask-upgrade
##

brew tap buo/cask-upgrade
brew cu -y -a --cleanup
# brew list --cask | xargs brew reinstall --cask ## alternatively, reinstall all softwares


brew cleanup

brew doctor

## Cleaning up.

brew cleanup
brew cleanup -s
rm -rf $(brew --cache)

## Restore $PATH.
export PATH=$OLD_PATH

## Say finished!
say "Updating homebrew (without installing any new software) finished!"
echo -ne '\007'

## END
