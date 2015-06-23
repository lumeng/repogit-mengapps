#!/usr/bin/env bash

# opendiff returns immediately, without waiting for FileMerge to exit.
# Piping the output makes opendiff wait for FileMerge.
opendiff "$@" | cat

