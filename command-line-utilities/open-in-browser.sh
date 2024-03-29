#!/usr/bin/env bash

##############################################################################
#+ Bash script to open something, usually an URL, in a browser app.
#+

## set up the DO_NOT_DISTURB environment variable:

#source ~/bin/symlinks/my_environment
#DO_NOT_DISTURB=false
#DO_NOT_DISTURB=true

TRUE_VALUE=true

DEBUG_PRINT_Q=false
#DEBUG_PRINT_Q=true

DEBUG_LEVEL="DEBUG"

if [[ $DEBUG_PRINT_Q ]]; then
    DEBUG_PRINT_BIN=echo
else
    :
fi

if [[ "$(uname -o)" == "Darwin" ]]; then
    BROWSER_BIN='/Applications/Firefox.app'
    BROWSER_BIN='/Applications/Google Chrome.app'
    BROWSER_BIN='/Applications/Thorium.app'
elif [[ "$(uname -o)" == "Linux" ]]; then
    BROWSER_BIN='/usr/bin/firefox'
    BROWSER_BIN='/usr/bin/google-chrome-stable'
fi

if [[ $DO_NOT_DISTURB = $TRUE_VALUE ]]; then
    $DEBUG_PRINT_BIN "[INFO] ${DO_NOT_DISTURB}"
    $DEBUG_PRINT_BIN "[INFO] DO_NOT_DISTURB is true!"
    :
else
    $DDEBUG_PRINT_BIN "[DEBUG] DO_NOT_DISTURB is NOT true!"
    $DEBUG_PRINT_BIN "[DEBUG] \$BROWSER_BIN: $BROWSER_BIN"
    open -na $BROWSER_BIN --args --profile-directory="Default" "$1"
fi

## END

