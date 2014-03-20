#!/usr/bin/env bash

## Meng Lu <lumeng.dev@gmail.com>
## 2013-10-28
##
## Repository: https://github.com/lumeng/repogit-mengapps/blob/master/file-system/add-filename-extension-to-image-files.sh
##
## Summary: identify image file type and add filename extension appropriately when applicable
##
## Example:
## $ add-filename-extension-to-image-files.sh -d ~/temp
##

IMAGE_FILE_DIR=

while getopts d:d opt; do
  case $opt in
  d)
      IMAGE_FILE_DIR=$OPTARG
      ;;
  esac
done

#echo "IMAGE_FILE_DIR="$IMAGE_FILE_DIR

#IMAGE_FILE_DIR=/Users/lumeng/Dropbox-x4430/Dropbox/DataSpace-Dropbox/Image/Wallpaper/kuvva_wallpaper/new/



if [[ -d $IMAGE_FILE_DIR ]]; then
	FILES=`find $IMAGE_FILE_DIR -maxdepth 1 -type f`
else
	FILES=()
fi


IMAGEMAGICK_IDENTIFY_BIN="/opt/local/bin/identify"


for file in $FILES
do
	filename=$(basename "$file")
    extension="${filename##*.}"
	if [ "$extension" == "$filename" ]; then
		newextension=`$IMAGEMAGICK_IDENTIFY_BIN $file | cut -d ' '  -f 2 | tr '[:upper:]' '[:lower:]'`
		rsync -qrthp $file "$file.$newextension"
		rm $file
	fi
done

## END
