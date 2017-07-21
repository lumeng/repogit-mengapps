#!/usr/bin/env bash

#################################################################################
#+ Summary: Start languagetool.org algorithmical proofread server on localhost.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ References: http://wiki.languagetool.org/http-server
##

## Source the right .bashrc_XXX file to have DROPBOX_PATH defined
REGEX='(.*)\.local'

HOST_NAME="$(hostname)"

if [[ $HOST_NAME =~ $REGEX ]]; then
	HOST_NAME=${BASH_REMATCH[1]}
fi

if [[ $HOST_NAME == "meng2maclap" ]]; then
	HOST_NAME="mengmaclap"
fi

source "$HOME/.bashrc_${HOST_NAME}"


## Put the software at one's favorite path
CLASS_PATH_ROOT="$DROPBOX_PATH/DataSpace-Dropbox/software/LanguageTool"

cd $CLASS_PATH_ROOT

java -cp languagetool-server.jar org.languagetool.server.HTTPServer --port 8081 > /dev/null 2>&1


## END
