#!/usr/bin/env bash

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}"/cvs-tag)

SRC_DIR="/Users/lumeng/WorkSpace-X4430/Wolfram/CVS/Alpha/Source/CalculateData/DataPaclets/"

CVS_ROOT="Alpha/Source/CalculateData/DataPaclets"

cd $SRC_DIR

counter=0

for file in *.m
do
	if [[ ! $counter < 0 ]]; then
		occurrence=`grep -c "Localize\[" $file`
		if [[ $occurrence > 0 ]]; then
			version=$(cvs log $file | ack -B 1 'author: (delaix|shenghuiy|yinwanl|chienyuc)' | head -n 1 | cut -d ' ' -f 2,2)
			if [[ $version =~ [0-9]\.[0-9]+ ]]; then
			    echo "file counter: $counter"
				echo "$file $version"
				cvs rtag -a -F -r "$version" "LocalizeWrapperComplete" "$CVS_ROOT/$file"
				((counter++))
			else
				echo "$file $version" >> "$TMP_DIR/bad.txt"
			fi
		fi
	fi
done


## Files that have 'Localize' wrappers but does not have a commit from t-alpha-localization developers who usually make a commit after reviewing the whole file and add Localize wrappers for the first time for the file.
echo "bad cases:"
cat "$TMP_DIR/bad.txt"

## END
