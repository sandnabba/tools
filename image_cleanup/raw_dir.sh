#!/bin/bash

echo $@ > /tmp/debug
echo $1 >> /tmp/debug

if [ -d "$1" ]; then
    echo "Setting path to $PWD"
    DIR_PATH="$1"
else
    echo "Path is broken!"
fi

echo "DIR_PATH = $DIR_PATH" >> /tmp/debug

cd "$DIR_PATH"

if [ ! -d "./RAW" ]; then
	mkdir RAW
fi

mv *.NEF RAW/
