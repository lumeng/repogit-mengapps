#!/usr/bin/env bash

## Summary: Convert all *.webp image files in a directory to *.png with
#* the original file name.
##

for f in *.webp
do
    dwebp -o $(basename $f ".webp").png $f
done

# END
