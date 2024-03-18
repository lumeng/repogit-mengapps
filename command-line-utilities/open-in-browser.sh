#!/usr/bin/env sh

##############################################################################
#+ Bash script to open something, usually an URL, in a browser app.
#+

## set up the DO_NOT_DISTURB environment variable:

#source ~/bin/symlinks/my_environment
#DO_NOT_DISTURB=false
#DO_NOT_DISTURB=true

TRUE_VALUE=true

## 
if [[ "$(uname -o)" = 'Darwin' ]]; then

    BROWSER_BIN='/Applications/Firefox.app'
    BROWSER_BIN='/Applications/Google Chrome.app'
    BROWSER_BIN='/Applications/Thorium.app'

    if [[ "${DO_NOT_DISTURB}" = "${TRUE_VALUE}" ]]; then
	#echo "${DO_NOT_DISTURB}"
	#echo "DO_NOT_DISTURB is true!"
	:
    else
	##echo "DO_NOT_DISTURB is NOT true!"
	open -na $BROWSER_BIN --args --profile-directory="Default" "$1"
    fi
fi

## END

