#!/usr/bin/env bash

df -lg | grep -vE '^Filesystem' | grep -vE '/private/var/vm$' | awk '{print $9 " " $4 }' | while read RESULT;

do
  DISK_SPACE=$(echo $RESULT | awk '{ print $2}' | cut -d'%' -f1  )
  MOUNTING_PATH=$(echo $RESULT | awk '{ print $1 }' )
  if [[ $DISK_SPACE -le 5 ]]; then
      say "${DISK_SPACE}GB disk space left"
      if [[ $MOUNTING_PATH -ne "/" ]]; then
	  say "at $MOUNTING_PATH!"
      fi
      echo "available disk space left: $(date -u +%Y-%m-%dT%H:%M:%SZ) $(hostname) ${DISK_SPACE}GB $MOUNTING_PATH !"
      # mail -s "Alert: ${DISK_SPACE}GB left at $MOUNTING_PATH" you@somewhere.com
  fi
done

## END

