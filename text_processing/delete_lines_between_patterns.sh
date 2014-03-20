#!/usr/bin/env bash

PATTERN_BEGINNING="<<<<<<<"
PATTERN_ENDING="========"


## awk '/<<<<<<< driver.c$/{f=1}/=======/{print;del;f=0}f' delete_lines_between_patterns_testdata.txt
FILE=
awk '/<<<<<<<\s.*/{a=1}/=======/{d;a=0}a' file
