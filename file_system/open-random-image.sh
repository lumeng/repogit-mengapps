#!/usr/bin/env bash

## set up the DO_NOT_DISTURB environment variable:
#source ~/bin/symlinks/my_environment
#DO_NOT_DISTURB=false
#DO_NOT_DISTURB=true

my_TRUE_VALUE=true

my_VIEWER_APP="Preview"

type '/Applications/qView.app/Contents/MacOS/qView' >/dev/null 2>&1 && my_VIEWER_APP='/Applications/qView.app/Contents/MacOS/qView'

#echo "[DEBUG] ${my_VIEWER_APP}"

if [[ -d $1 ]]; then
    my_IMAGE_DIR=$1
else
    my_IMAGE_DIR="$HOME/Google Drive/DataSpace-GoogleDrive/image/infographic_信息图"
fi

# [DEBUG]
#echo "[DEBUG] ${my_IMAGE_DIR}"

if [[ -e /usr/bin/find ]]; then
    my_FIND_BIN=/usr/bin/find
fi

if [[ -e /usr/local/bin/gfind ]]; then
    my_FIND_BIN=/usr/local/bin/gfind
fi

my_IMAGE=$($my_FIND_BIN "${my_IMAGE_DIR}" -type f -regextype posix-extended -regex '.*\.(jpg|jpeg|png|gif|bmp|webp|pdf)' | shuf -n1)

# [DEBUG]
# echo "[DEBUG] ${my_IMAGE}"

if [ "${DO_NOT_DISTURB}" = "${my_TRUE_VALUE}" ]; then
    :
else
    /usr/bin/open -a "${my_VIEWER_APP}" "${my_IMAGE}"
fi

# END

