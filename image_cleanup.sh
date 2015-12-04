#!/bin/bash

if [ -z "$1" ]; then
    echo "Setting path to $PWD"
    DIR_PATH=$PWD
else
    DIR_PATH=$1
fi

IFS=$'\n'

FILE_LIST=$(find "$DIR_PATH")
DELETE_LIST="" # Empty to start with

# Start with finding all RAW-files:
for line in $FILE_LIST; do
    if [[ $line =~ .*\.NEF$ ]]; then
	# What to do with full path to RAW-file:

	# Get the Jpeg name:
        JPEG_NAME=$(echo $line | grep -E -o "_DSC[0-9]+\.")jpg
	if ! [[ "$FILE_LIST" =~ $JPEG_NAME ]]; then
	    # If jpeg does not exists, add file to delete-list:§
	    DELETE_LIST="$DELETE_LIST$line\n"
	fi
	
    fi
done

echo "List of files that will be deleted:"
echo -e $DELETE_LIST
