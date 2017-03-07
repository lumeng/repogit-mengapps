#!/usr/bin/env bash

type wolframscript >/dev/null 2>&1 || { echo >&2 "This script requires command-line executable program 'wolframscript', that is installed along with Wolfram Mathematica version 11 or later. See more information at http://reference.wolfram.com/language/ref/program/wolframscript.html. Aborting."; exit 1; }

URL=$1

wolframscript -code "URLShorten[\"$URL\"]"

## END
