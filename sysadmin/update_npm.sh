#!/usr/bin/env bash

##
#+ Script for updating npm and its packages.
#+
##

## If brew is not installed, exit.
if [[ $(uname) == 'Darwin' ]]; then
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }
fi

##############################################################################
#+ Update Homebrew
##
if [[ -f ./update_homebrew.sh ]]; then
    source ./update_homebrew.sh
else
    echo "Cannot find script ./update_homebrew.sh. Please update Homebrew first."
    exit 1
fi

################################################################################
#+ Install npm.
##

## 2017-7-20： Install npm via Homebrew.
if [[ $(uname) == 'Darwin' ]]; then
    type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }
    brew list npm > /dev/null || { echo >&2 "npm is not installed via Homebrew. Aborting."; exit 1; }

fi

## Upgrading npm.
npm install npm@latest -g


################################################################################
#+ Install npm packages.
#+
#+ ## Verify if a package is installed, if it is, update it, if not, install it:
#+
#+ $ # Assuming the package 'pug' is already installed.
#+ $ npm list -g pug > /dev/null
#+ $ echo $?
#+ $ 0
#+ $ # Assuming the package 'foobar' is NOT already installed.
#+ $ npm list -g foobar > /dev/null
#+ $ echo $?
#+ $ 1
##

## On macOS, use /usr/local/bin
if [[ $(uname) == 'Darwin' && -d '/usr/local/bin' ]]; then
    export PATH="/usr/local/bin:$PATH"  ## Make sure brew is on the path before checking its existence.
fi

## 2017-11-22: Install and update minimatch.
npm list -g minimatch > /dev/null || (npm install -g minimatch && npm update -g minimatch)


## 2017-11-24: Install and update pug.
npm list -g pug > /dev/null || (npm install -g pug && npm update -g pug)


## 2017-12-3: Install and update iterm2-tab-set.
npm list -g iterm2-tab-set > /dev/null || (npm install -g iterm2-tab-set && npm update -g iterm2-tab-set)


## 2017-12-14: Install and update express (https://expressjs.com/).
npm list -g express > /dev/null || (npm install -g express && npm update -g express)


## 2017-12-19: Install and update alexa-sdk (https://alexa.design).
npm list -g alexa-sdk > /dev/null || (npm install -g alexa-sdk && npm update -g alexa-sdk)


## Alexa Skills Kit Command-Line Interface (ASK CLI), https://alexa.design/cli
npm list -g ask-cli > /dev/null || (npm install -g ask-cli && npm update -g ask-cli)


## 2017-12-20: Install and update http.
npm list -g http > /dev/null || (npm install -g http && npm update -g http)


## 2018-1-5: Intall and update mastodon
npm list -g mastodon > /dev/null || (npm install -g mastodon && npm update -g mastodon)


## 2018-1-5: Intall and update oauth
npm list -g oauth > /dev/null || (npm install -g oauth && npm update -g oauth)


## 2018-1-9: Intall and update twitter
npm list -g twitter > /dev/null || (npm install -g twitter && npm update -g twitter)


npm list -g url-exists > /dev/null || (npm install -g url-exists && npm update -g url-exists)


npm list -g jquery > /dev/null || (npm install -g jquery && npm update -g jquery)

## 2018-1-10: Install and update [mocha](https://mochajs.org)
npm list -g mocha > /dev/null || (npm install -g mocha && npm update -g mocha)


## more ...

##############################################################################
#+ Restore $PATH.
##
export PATH=$OLD_PATH

## END
