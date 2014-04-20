#!/usr/bin/env bash

##
## ## Summary: identify image file type and add filename extension appropriately when applicable
##
## ## Author: Meng Lu <lumeng.dev@gmail.com>
##
## ## History:
## * 20140420: Added many improvements:
##      * Quit the script at the first failcure "set -e";
##      * Test existence of dependency utility "identify"; If it does
##        not exist, quit the script with error.
##      * Test the existence of image folder;  If it does not exist, quit the
##        script with error.
##      * Expand aliases and run .bashrc explicitly if the script is not run
##        from an interactive shell in order to get paths such as
##        /usr/local/bin/ on $PATH so the availability test
##        "hash identify 2>/dev/null" work;
##     * Added various INFO, DEBUG, and ERROR printing.
##     * Improved the logic for determing if a file name needs to have extension
##       added, i.e. iff new extension and current extension are NOT same.
## * 20131028: initial commit
##
## ## Repository: https://github.com/lumeng/repogit-mengapps/blob/master/file-system/add-filename-extension-to-image-files.sh
##
## ## Example:
## $ add-filename-extension-to-image-files.sh -d ~/temp
##


## quit the script if whenever a failure is occuring without attempting any following commands
set -e

## quit if imagemagick or the image files do not exist

while getopts d:d opt; do
  case $opt in
  d)
      IMAGE_FILE_DIR=$OPTARG
      ;;
  esac
done

## Sometimes it might be useful to hard code the folder here rather than specifying it at command line with option -d
#IMAGE_FILE_DIR=/Users/lumeng/Dropbox-x4430/Dropbox/DataSpace-Dropbox/Image/Wallpaper/kuvva_wallpaper/new/



if [ -d "$IMAGE_FILE_DIR" ]; then
	FILES=`find $IMAGE_FILE_DIR -maxdepth 1 -type f`
else
	echo >&2 "[ERROR] $IMAGE_FILE_DIR is a bad directory"
	exit 1
fi


## If running from a non-interactive shell, the aliases are not automatically expanded
## Rather than hard coding the full path
##   IMAGEMAGICK_IDENTIFY_BIN="/usr/local/bin/identify"
## expand the aliases and source .bashrc explicitly
##
## ## Reference:
## * http://www.cyberciti.biz/faq/linux-unix-bash-check-interactive-shell/
## * http://serverfault.com/questions/119273/how-to-use-my-aliases-in-my-crontab
if [ -z "$PS1" ]; then
	shopt -s expand_aliases
    source "$HOME/.bashrc"
fi


if hash identify 2>/dev/null; then
	#echo "[DEBUG] identify exists! good!"
	IMAGEMAGICK_IDENTIFY_BIN=identify
else
	echo >&2 "[ERROR] $IMAGEMAGICK_IDENTIFY_BIN; the utility 'identify' does not exist! On Mac OS X, install package 'imagemagick' by 'brew install imagemagick'!"
	exit 1
fi


## Add file name extensions
echo "[INFO] Adding file name extensions to files in directory IMAGE_FILE_DIR=$IMAGE_FILE_DIR ..."

for file in $FILES
do
	filename=$(basename "$file")
    extension="${filename##*.}"
	#echo "[DEBUG] extension: $extension"
    newextension=`$IMAGEMAGICK_IDENTIFY_BIN $file 2>/dev/null| cut -d ' '  -f 2 | tr '[:upper:]' '[:lower:]'`
	#echo "[DEBUG] newextension: $newextension"
	if [ ! "$extension" = "$newextension" ]; then
		rsync -qrthp $file "$file.$newextension" && rm $file && echo -e "[INFO] renamed\n\t$filename\nto\n\t$filename.$newextension\n!"
	else
		echo "[INFO] skipping $filename"
	fi
done

echo "[INFO] done!"

## END
