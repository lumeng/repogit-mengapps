#!/usr/bin/env bash

## Enable readline support for Mathematica command-line.

COMPLETION_FILE="$(brew --prefix)/share/rlwrap/completion/MathKernel"

rlwrap --file $COMPLETION_FILE math

## END