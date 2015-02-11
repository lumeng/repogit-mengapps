#!/usr/bin/env bash
##
#+ Summary: compress multiple files into zip seperately using 7z.
#+
#+ ## Author: Meng Lu <lumeng.dev@gmail.com>
##
#+ ## Usage:
#+     $ compress.sh myfile_foobar_*.mkv
#+ will create
#+     myfile_foobar_1.mkv.7z
#+     myfile_foobar_2.mkv.7z
#+     ...
#+ if the pattern myfile_foobar_*.mkv matches files
#+    myfile_foobar_1.mkv
#+    myfile_foobar_2.mkv
#+
#+ ## TODO
#+ * Use getopts (not getopt) to get options for metadata and other
#+ optional parameters
#+
##    ...

## Metadata to include for www.x1949x.com
XLWMETADATA="${DROPBOX_PATH%%/}/DataSpace-Dropbox/ToUpload/小狼窝宣传文件"

if [ -f "$XLWMETADATA" ]; then
	echo "Bad metadata path $XLWMETADATA"
	exit
fi

for var in "$@"
do
    echo "`date` Start to compress $var"
    7z a \
	-p \
    -t7z \
    -m0=lzma2 \
    -mx=5 \
    -ms=on \
    -mfb=64 \
    -md=32m \
	"${var}.7z" \
    "${var}" \
    "$XLWMETADATA"
    echo "`date` done!"
done

## END

