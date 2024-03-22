#!/usr/bin/env bash

## Summary: Play music.
#+
#+ * TODO: add more exception handling
#+ * TODO: add more documentation
##

## Define music folders.
if [[ $(hostname) == 'x3872' ]]; then
    TO_LISTEN_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/to_listen'
    MUSIC_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/favorite_music'
    SONG_FOLDER='/mnt/c/Users/lumeng/百度云同步盘/DataSpace-Baidu/Music/favorite_song'
else
    TO_LISTEN_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/to_listen"
    MUSIC_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/favorite_music"
    SONG_FOLDER="$HOME/Google Drive/DataSpace-GoogleDrive/Music/favorite_song"
fi

## Define find command.
if [[ $(hostname) == 'x3872' ]]; then
    FIND_CMD='/usr/bin/find'
elif [[ $(uname -s) == 'Darwin' ]]; then
    FIND_CMD=/usr/local/bin/gfind
else
    FIND_CMD=$(which find)
fi


FILE_FOLDER="${TO_LISTEN_FOLDER}"
FILE_FOLDERS=("${MUSIC_FOLDER}", "${SONG_FOLDER}", "${TO_LISTEN_FOLDER}")

while getopts ":msr" opt; do
  case ${opt} in
      s) # song
         FILE_FOLDER=${SONG_FOLDER}
         ;;
      m) # music
         FILE_FOLDER=${MUSIC_FOLDER}
         ;;
      r) # random
	 RANDOM_IDX=$(jot 1 0 2)
         FILE_FOLDER="${FILE_FOLDERS[$RANDOM_IDX]}"
         ;;
      \?) echo "Usage:
* song: my-play-music -s
* music: my-play-music -m
* music: my-play-music -r
* the folder \"to-listen\": my-play-music
"
         FILE_FOLDER="${TO_LISTEN_FOLDER}"
         ;;
  esac
done

if [[ $(uname -s) == 'Darwin' ]]; then
    /usr/bin/osascript -e "set Volume 3"
fi


if [[ $(hostname) == 'x3872' ]]; then
    #MY_PLAYER=wslview
    MY_PLAYER='/mnt/c/Program Files/VideoLAN/VLC/vlc.exe'
elif [[ $(uname -s) == 'Darwin' ]]; then
    MY_PLAYER='/usr/local/bin/vlc --intf=macosx' # --intf: dummy, lua, c.f. https://wiki.videolan.org/Interfaces/
else
    MY_PLAYER=$(which vlc)
fi

##
#+ * -d: show full file path
#+ * -t: sort by modification time
#+
##

if [[ -d "${FILE_FOLDER}" ]]; then

    echo "folder: ${FILE_FOLDER}"

    ## Play some oldest files since the last access time.
    $FIND_CMD "${FILE_FOLDER}" -type f -regextype posix-extended -regex '.*\.(ape|flac|flv|mkv|mp3|mp4|ogg|opus|wav|webm)' -printf "\n%AD %AT %p" | sort -n -t"/" -k3 -k1 -k2 -k4 | sed '/^ *$/d' | head -2 | cut -d ' ' -f 3- | while read f; do
        pkill -f 'VLC.app'
        echo "file: $f"
        $MY_PLAYER -Z --play-and-exit "$f"
	touch -a "$f"
    done

    ## Play some files randomly chosen.
    $FIND_CMD "${FILE_FOLDER}" -type f -regextype posix-extended -regex '.*\.(ape|flac|flv|mkv|mp3|mp4|ogg|opus|wav|webm)' | sort -R | tail -1 | while read f; do
        pkill -f 'VLC.app'
        echo "file: $f"
        $MY_PLAYER -Z --play-and-exit "$f"
        touch -a "$f"
    done

    ## Play some files from the to-listen folder.
    if [[ -d "${TO_LISTEN_FOLDER}" ]]; then
        echo "folder: ${TO_LISTEN_FOLDER}"

        $FIND_CMD "${TO_LISTEN_FOLDER}" -type f -regextype posix-extended -regex '.*\.(ape|flac|flv|mkv|mp3|mp4|ogg|opus|wav|webm)' | shuf -n 2 | while read f; do
            pkill -f 'VLC.app'
            echo "file: $f"
            $MY_PLAYER -Z --play-and-exit "$f"
            touch -a "$f"
        done
    fi

else
    echo "[ERR] bad file folder: ${FILE_FOLDER}"
fi

## EOF
