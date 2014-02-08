#!/usr/bin/env bash

## Summary: restart adb (Android Debug Brdige) server.

## adb binary full path
if [ `echo $USER` == "meng" ] || [ `echo $USER` == "lumeng" ]
then
	echo "for user $USER, set adb executable path automatically ..."
	DIR=`dirname $DROPBOX_PATH`
	ADB_BIN="$DIR/DataSpace-Meng2Maclap/Software/adt-bundle-mac-x86_64-20131030/sdk/platform-tools/adb"
else
	echo "Please set path of Android Debug Bridge (adb) executable path in $0"
	exit
fi

#ADB_BIN=adb  ## this allows adb exposed to $Path
#ADB_BIN=./adb  ## this only allows running this script in path where adb exist


if pgrep adb >/dev/null 2>&1
then
	echo "adb is running"
	echo "terminating adb ..."
	$ADB_BIN kill-server
	if pgrep adb >/dev/null 2>&1
	then
		echo "did not work"
		echo "kill adb processes by killall"
		killall -9 adb
	else
		echo "terminated"
	fi
else
	echo "adb is not running"
fi

echo "starting adb ..."

$ADB_BIN start-server

echo "adb process:"

echo `pgrep adb`

echo "done"

# END
