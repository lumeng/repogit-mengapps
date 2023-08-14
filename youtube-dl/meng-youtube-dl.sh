#!/usr/bin/env bash

##
## ## Summary: use youtube-dl to download files from YouTube.
##
## ## Author: Meng Lu <lumeng.dev@gmail.com>
##
## ## History:
## 2023-5-17:

usage() { echo "Usage: $0 [-f <a|>]" 1>&2; exit 1; }

while getopts ":f:" o; do
    case "${o}" in
        f)
            f=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "${f}" ]]; then
    usage
fi


LS_CMD='ls -l -a -t'

if command -v exa >/dev/null; then
    LS_CMD='exa --long --all --sort=newest'
fi

# echo "[DEBUG] LS_CMD=$LS_CMD"


if [[ ${f} == "a" ]]; then
    youtube-dl -f 251 -ci "$HOME/Temp/youtube-dl_download_archive.txt" "$@" \
        && youtube-dl -f 140 -ci --download-archive "$HOME/Temp/youtube-dl_download_archive.txt" "$@"
else
    youtube-dl -ci --download-archive "$HOME/Temp/youtube-dl_download_archive.txt" "$@"
fi

echo 'To convert *.webm file to *.opus file, use the following command (c.f. https://superuser.com/questions/1234492/is-it-ok-to-rename-webm-audio-only-files-to-opus):'
echo 'mkvextract file/something.web tracks 0:something.opus'

$LS_CMD ./*.webm

## END
