#!/usr/bin/env bash

#################################################################################
#+ Summary: find age of a file in a CVS repository
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ 
#+ Example:
#+
#+     $ pwd
#+     /path/to/cvs/root/dir/
#+     $ /path/to/cvs-age.sh somefile
#+     1510
#+
#+ where '1510' is the number of days.
#+ ## Note
#+ * The calculation assumes the date in the 'cvs log' output is in time zone UTC.
#+ * The result is an approximation in days.
##

DATE_BIN=gdate

FILE="$1"

if [[ ! -e $FILE ]]; then
    echo "ERROR: file does not exist: $FILE"
    exit 1
fi
	   
NOW=$(( $($DATE_BIN +%s -u)/3600/24 ))

birth_time=$(cvs log $FILE | grep -A 1 '^revision 1\.1$' | tail -n 1 | cut -d ' ' -f 2,2 | cut -d ';' -f 1)

birth_date=$(( $($DATE_BIN +%s -u -d  ${birth_time})/3600/24 ))

age=$(( $NOW-${birth_date} ))

echo $age

## END
