#!/usr/bin/env bash

## Summary: Play music.
#+
#+ * TODO: add more exception handling
#+ * TODO: add more documentation
##

MUSIC_FOLDER="/Users/meng/百度云同步盘/DataSpace-Baidu/Music/favorite_music/"
SONG_FOLDER="/Users/meng/百度云同步盘/DataSpace-Baidu/Music/favorite_song/"

while getopts ":ms" opt; do
  case ${opt} in
      s ) # process option t
	  FILE_FOLDER=${SONG_FOLDER}
	  ;;
      m )
	  FILE_FOLDER=${MUSIC_FOLDER}
	  ;;  
     \? ) echo "Usage:
                  * music: my-play-music -m
                  * song: my-play-music -s
"
	  FILE_FOLDER=${MUSIC_FOLDER}
	  ;;
  esac
done

/usr/bin/osascript -e "set Volume 2"

MY_PLAYER=/usr/local/bin/vlc


##
#+ * -d: show full file path
#+ * -t: sort by modification time
#+
##
if [[ -d ${FILE_FOLDER} ]]; then
    ls -t -d ${FILE_FOLDER} | tail -3 | while read f; do
        $MY_PLAYER -Z --play-and-exit "$f" >/dev/null 1>&2
    done
    
    ls -d ${FILE_FOLDER} | sort -R | tail -2 | while read f; do
        $MY_PLAYER -Z --play-and-exit "$f" >/dev/null 1>&2
    done
fi

## EOF
