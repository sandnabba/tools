#!/bin/bash

if [ -z "$1" ]; then
    echo "Setting path to $PWD"
    DIR_PATH=$PWD
else
    DIR_PATH=$1
fi

IFS=$'\n'
shopt -s nocasematch

FILE_LIST=$(find "$DIR_PATH")
DELETE_LIST="" # Empty to start with

# Start with finding all RAW-files:
for line in $FILE_LIST; do
  if [[ $line =~ .*\.NEF$ ]]; then
  	# What to do with full path to RAW-file:
  	# Get the Jpeg name:
    JPEG_NAME=$(echo $line | grep -E -o "_?DSC_?[0-9]+\.")jpg
  	if ! [[ "$FILE_LIST" =~ $JPEG_NAME ]]; then
      # If jpeg does not exists, add file to delete-list:§
  	  DELETE_LIST=$DELETE_LIST$'\n'$line
  	fi
  fi
done

# Check size of DELETE_LIST here, and quit if it's empty

echo "List of files that will be deleted:"
for line in $DELETE_LIST; do
    echo $line
done
echo -e "Continue? [yN]: \c"
read REPLY

if [ -z $REPLY ]; then
    echo "Quitting"
elif [ $REPLY == "y" ]; then
    for line in $DELETE_LIST; do
        rm -v $line
    done
else
echo "Quitting"
fi
