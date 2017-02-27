#!/bin/bash

# This is a generic script for managing btrfs snapshots in the format:
# /path/$NAME_PREFIX-$YEAR-$MONTH-$DAY
# By default it will keep daily snapshots for 30 days, weekly snapshots for 3 months
# and monthly snapshots for 1 year.


if [ $# -eq 0 ]; then
  echo "No arguments supplied"
  exit 1
else
  NAME_PREFIX="$1"
fi

SNAPSHOT_DIR="/btrfs/snapshots"
DELETE_COMMAND="btrfs subvolume delete"

# Debug:
#TODAY="2017-03-01"
#DAY=2
#CURRENT_MONTH=3
#YEAR=2017

TODAY=$(date +20%y-%m-%d)
DAY=$(date +%d)
CURRENT_MONTH=$(date +%m)
YEAR=$(date +20%y)

if [ $CURRENT_MONTH -eq 1 ]; then
  LAST_MONTH=12
  TWO_MONTHS_AGO=11
  YEAR=$(expr $YEAR - 1)
elif [ $CURRENT_MONTH -eq 2 ]; then
  LAST_MONTH=1
  TWO_MONTHS_AGO=12
else
  LAST_MONTH=$(expr $CURRENT_MONTH - 1)
  TWO_MONTHS_AGO=$(expr $CURRENT_MONTH - 2)
fi
if [ "$DAY" -le "9" ]; then
  DAY="0$DAY"
fi
if [ "$LAST_MONTH" -le "9" ]; then
  LAST_MONTH="0$LAST_MONTH"
fi
if [ "$TWO_MONTHS_AGO" -le "9" ]; then
  TWO_MONTHS_AGO="0$TWO_MONTHS_AGO"
fi

# Stop if we don't have a snapshot for today:
if [ ! -d "$SNAPSHOT_DIR"/"$NAME_PREFIX""$TODAY" ];
then
  echo "CRITICAL: Snapshot for today does not exist!"
  echo "$SNAPSHOT_DIR"/"$NAME_PREFIX""$TODAY"
  exit 2
fi

# If first day of month, delete all remaning snapshots for month-2:
if [ $DAY -eq 1 ]; then
  for DAY in {2..31}; do
    if [ "$DAY" -le "9" ]; then
      DAY="0$DAY"
    fi
    if [ $CURRENT_MONTH -eq 2 ]; then
      YEAR=$(expr $YEAR - 1)
    fi
    #echo checking "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$TWO_MONTHS_AGO"-"$DAY"
    if [ -d "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$TWO_MONTHS_AGO"-"$DAY" ]; then
      #echo Removing "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$TWO_MONTHS_AGO"-"$DAY"
      $($DELETE_COMMAND "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$TWO_MONTHS_AGO"-"$DAY")
    fi
  done
else
  # Just delete last month's snapshot
  #echo "Removing "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$LAST_MONTH"-"$DAY""
  $($DELETE_COMMAND "$SNAPSHOT_DIR"/"$NAME_PREFIX""$YEAR"-"$LAST_MONTH"-"$DAY")
fi
