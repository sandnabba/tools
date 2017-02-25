#!/bin/bash

# This is a generic script for managing backups in the format:
# /path/$NAME_PREFIX-$YEAR-$MONTH-$DAY
# By default it will keep daily snapshots for 30 days, weekly snapshots for 3 months
# and monthly snapshots for 1 year.

NAME_PREFIX=test
SNAPSHOT_DIR=/home/emil/temp/snapshots
DELETE_COMMAND="rmdir"


TODAY=$(date +20%y-%m-%d)
DAY=$(date +%d)
CURRENT_MONTH=$(date +%m)
YEAR=$(date +20%y)

if [ $CURRENT_MONTH -eq 11 ]; then
  LAST_MONTH="10"
elif [ $CURRENT_MONTH -eq 12 ]; then
  LAST_MONTH="11"
elif [ $CURRENT_MONTH -eq 1 ]; then
  LAST_MONTH="12"
else
  LAST_MONTH="0"$(expr $CURRENT_MONTH - 1)
fi

echo "$SNAPSHOT_DIR"/"$NAME_PREFIX"_"$TODAY"

# Stop if we don't have a snapshot for today:
if [ ! -d "$SNAPSHOT_DIR"/"$NAME_PREFIX"_"$TODAY" ];
then
  echo "CRITICAL: Today does not exist!"
  exit 2
fi

# Delete yesterdays snapshot:
$($DELETE_COMMAND "$SNAPSHOT_DIR"/"$NAME_PREFIX"_"$YEAR"-"$LAST_MONTH"-"$DAY")
