#!/usr/bin/env bash

## Summary: Play music.
#+
#+ * TODO: add more exception handling
#+ * TODO: add more documentation
##

if [[ $(hostname) == 'x3872' ]]; then
    TO_LISTEN_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/to_listen'
    MUSIC_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/favorite_music'
    SONG_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/favorite_song'
else
    TO_LISTEN_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/to_listen"
    MUSIC_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/favorite_music"
    SONG_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/favorite_song"
fi


if [[ $(hostname) == 'x3872' ]]; then
    FIND_CMD='/usr/bin/find'
elif [[ $(uname) == 'Darwin' ]]; then
    FIND_CMD=/usr/local/bin/gfind
else
    FIND_CMD=$(which find)
fi


FILE_FOLDER=${MUSIC_FOLDER}

while getopts ":ms" opt; do
  case ${opt} in
      s) # process option t
         FILE_FOLDER=${SONG_FOLDER}
         ;;
      m) # process option t
         FILE_FOLDER=${MUSIC_FOLDER}
         ;;
      \?) echo "Usage:
* song: my-play-music -s
* music: my-play-music -m
* the folder \"to-listen\": my-play-music
"
         FILE_FOLDER="${TO_LISTEN_FOLDER}"
         ;;
  esac
done

if [[ $(uname) == 'Darwin' ]]; then
    /usr/bin/osascript -e "set Volume 3"
fi


if [[ $(hostname) == 'x3872' ]]; then
    #MY_PLAYER=wslview
    MY_PLAYER='/mnt/c/Program Files/VideoLAN/VLC/vlc.exe'
else
    MY_PLAYER=$(which vlc)
fi

##
#+ * -d: show full file path
#+ * -t: sort by modification time
#+
##

if [[ -d "${FILE_FOLDER}" ]]; then
    if [[ -d "${TO_LISTEN_FOLDER}" ]]; then
        $FIND_CMD "${TO_LISTEN_FOLDER}" -type f | shuf -n 2 | while read f; do
            pkill -f 'VLC.app'
            echo "$f"
            $MY_PLAYER -Z --play-and-exit "$f"
        done
    fi
    ## play some oldest files since the last access time
    $FIND_CMD "${FILE_FOLDER}" -type f -printf "\n%AD %AT %p" | tail -n 10 | sort -R | tail -1 | while read f; do
        pkill -f 'VLC.app'
        echo "$f"
        $MY_PLAYER -Z --play-and-exit "$f"
    done
    $FIND_CMD "${FILE_FOLDER}" -type f | sort -R | tail -1 | while read f; do
        pkill -f 'VLC.app'
        echo "$f"
        $MY_PLAYER -Z --play-and-exit "$f"
    done
fi

## EOF
