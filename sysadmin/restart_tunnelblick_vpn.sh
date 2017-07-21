#!/usr/bin/env bash

## Restart a VPN connection using Tunnelblick.
#+ References: https://tunnelblick.net/cAppleScriptSupport.html#controlling-tunnelblick-from-the-command-line
##
osascript -e "tell application \"Tunnelblick\"" -e "disconnect \"my-vpn\"" -e "end tell"

osascript -e "tell application \"Tunnelblick\"" -e "connect \"my-vpn\"" -e "end tell"


## END
