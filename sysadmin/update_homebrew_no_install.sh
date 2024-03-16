#!/usr/bin/env bash

##
#+ Script for updating Homebrew.
#+
##

##############################################################################
## Abort if not on Mac OS X.
if [[ ! $(uname) == 'Darwin' ]]; then
    echo >&2 "Since Homebrew is a package management system for macOS (formerly known as Mac OS X), it does not make sense to update it on $(uname). Abort."
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


################################################################################
#+ Update Homebrew Git repo.
#+
#+

#+ References:
#+ * http://apple.stackexchange.com/questions/277386/how-to-upgrade-homebrew-itself-not-softwares-formulas-installed-by-it-on-macos
#+ * http://discourse.brew.sh/t/how-to-upgrade-brew-stuck-on-0-9-9/33

cd "$(brew --repo)" && git fetch && git reset --hard origin/master && git clean -i


##############################################################################
#+ Fix ownership and permission of Homebrew related file paths.
#+
#+ * c.f.
#+   * <https://apple.stackexchange.com/questions/1393/are-my-permissions-for-usr-local-correct>
#+   * <https://www.google.com/search?q=%22%2Fusr%2Flocal%22+%22root%3Awheel%22+homebrew>
#+   * https://apple.stackexchange.com/questions/470617/safe-way-to-fix-ownership-and-permission-of-homebrew-related-directories-as-part
#+ * Old remark (possibly circa 2020 or earlier):
#+ Homebrew no longer needs to have ownership of /usr/local. If you wish you can
#+ return /usr/local to its default ownership with:
#+ bash% sudo chown root:wheel /usr/local
#+
#+ ```
#+ if [[ -d /usr/local/munki ]]; then
#+ sudo chown -R root:wheel /usr/local/munki
#+ sudo chmod -R o-w /usr/local/munki
#+ fi
#+ ```
#+
####

## Fix owner of files and folders recursively.
## sudo chown root:wheel /usr/local ## This is no longer necessary nor possible as of 2024-3 (macOS 14.4, Homebrew 4.1.0) as /usr/local is by default owned by root:wheel and not changeable.
sudo chown -R $(whoami):wheel $(brew --prefix)/* /opt/homebrew-cask
sudo chown -R $(whoami) "$HOME/Library/Caches/Homebrew"

## Fix read and write permission of files and folders recursively.
chmod -R u+rw $(brew --prefix)/* /opt/homebrew-cask "$HOME/Library/Caches/Homebrew"

## Fix execute permission of folders recursively.
find $(brew --prefix) /opt/homebrew-cask "$HOME/Library/Caches/Homebrew" -type d -exec chmod ug+x '{}' \;

## Fix write permission of zsh folders. c.f. <https://archive.ph/dL8U1>
type zsh >/dev/null 2>&1 && type compaudit >/dev/null 2>&1 && compaudit | xargs chmod g-w


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
say "Updating homebrew (without installing any new softwares) finished!"
echo -ne '\007'

## END
