#!/usr/bin/env bash

#################################################################################
#+ Summary: update Git-MediaWiki after updating Git.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ Description:
#+ After updating Git using
#+     brew upgrade git
#+ on Mac OS X or using
#+     sudo apt-get update git-all
#+ on Ubuntu Linux, Git-MediaWiki will be broken. It can be updated/fixed with
#+ instructions in https://meng6.net/pages/computing/installing_and_configuring/installing_and_configuring_git-mediawiki/#.Vu3sWxIrJE4
#+
#################################################################################

REGEX='(.*)\.local'

HOST_NAME="$(hostname)"

if [[ $HOST_NAME =~ $REGEX ]]; then
	HOST_NAME=${BASH_REMATCH[1]}
fi

## This arbitrarily assumes git://git.kernel.org/pub/scm/git/git.git
#+ is checked out at the following workspace directory.
##
WORKSPACE_DIR="$HOME/WorkSpace-$HOST_NAME/repos-external"

if [[ -d "$WORKSPACE_DIR" ]]; then
	cd "$WORKSPACE_DIR"
	cd git
	git pull
fi
	
if [[ -f "$WORKSPACE_DIR/git/.git/config" ]]; then
	sudo cp contrib/mw-to-git/git-remote-mediawiki.perl "$(git --exec-path)/git-remote-mediawiki"
	sudo chmod a+x "$(git --exec-path)/git-remote-mediawiki"
	sudo cp contrib/mw-to-git/git-mw.perl "$(git --exec-path)/git-mw"
	sudo chmod a+x "$(git --exec-path)/git-mw"
else
    >&2 echo "This script currently assumes the Git repository git://git.kernel.org/pub/scm/git/git.git is cloned to $WORKSPACE_DIR/git but it is not a valid Git repository (.git/config does not exist.)"
	exit 1
fi

## END
