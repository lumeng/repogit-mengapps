#!/usr/bin/env bash

if [[ "$(uname -o)" = 'Darwin' ]]; then 
    wifidev="$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')"
    networksetup -setairportpower $wifidev off; networksetup -setairportpower $wifidev on
	elsif [[ "$(uname -o)" = 'Linux' ]]; then
	# TODO
fi


## END
