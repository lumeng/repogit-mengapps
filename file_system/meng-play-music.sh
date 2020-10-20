#!/usr/bin/env bash

## Summary: Play music.
#+
#+ * TODO: add more exception handling
#+ * TODO: add more documentation
##

MUSIC_FOLDER="$HOME/百度云同步盘/DataSpace-Baidu/Music/favorite_music/"
SONG_FOLDER="$HOME/百度云同步盘/DataSpace-Baidu/Music/favorite_song/"
FILE_FOLDER=${MUSIC_FOLDER}

while getopts ":ms" opt; do
  case ${opt} in
      s) # process option t
         FILE_FOLDER=${SONG_FOLDER}
         ;;
      \?) echo "Usage:
* song: my-play-music -s
* music: my-play-music
"
         FILE_FOLDER=${MUSIC_FOLDER}
         ;;
  esac
done

/usr/bin/osascript -e "set Volume 3"

MY_PLAYER=/usr/local/bin/vlc


##
#+ * -d: show full file path
#+ * -t: sort by modification time
#+
##
if [[ -d ${FILE_FOLDER} ]]; then
    ls -t -r ${FILE_FOLDER} | tail -10 | sort -R | tail -1 | while read f; do
        pkill -f 'VLC.app'
        echo "$f"
	$MY_PLAYER -Z --play-and-exit "${FILE_FOLDER}/$f"
    done
    ls -t ${FILE_FOLDER} | sort -R | tail -1 | while read f; do
        pkill -f 'VLC.app'
        echo "$f"
	$MY_PLAYER -Z --play-and-exit "${FILE_FOLDER}/$f"
    done
fi

## EOF
