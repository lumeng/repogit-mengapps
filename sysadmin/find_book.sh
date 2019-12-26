#!/usr/bin/env bash

type find >/dev/null 2>&1 || { echo >&2 "This script requires command-line executable program 'wolframscript', that is installed along with Wolfram Mathematica version 11 or later. See more information at http://reference.wolfram.com/language/ref/program/wolframscript.html. Aborting."; exit 1; }

BOOK_FILENAME=$1

find {/Volumes/{library2,LIBRARY3},~/DataSpace-Library} -iname '$*{BOOK_FILENAME}*'

# END

