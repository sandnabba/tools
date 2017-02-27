#!/bin/bash

# Script/function to send an incremental snapshot of a btrfs file system

SNAPSHOT_DIR="/btrfs/snapshots"
REMOTE_USER="username"
REMOTE_HOST="remote.example.com"

# Todays date:
TIMESTAMP=$(date +20%y-%m-%d)

function send_snapshot {
  NAME_PREFIX="$1"
  SNAPSHOT_NAME="$NAME_PREFIX""$TIMESTAMP"

  # Check if we have a last snapshot:
  if [ -e ""$SNAPSHOT_DIR"/"$1".last_sent" ]; then
    LAST_SNAPSHOT=$(cat "$SNAPSHOT_DIR"/"$1".last_sent)
    #echo Running: btrfs send -c "$SNAPSHOT_DIR"/"$LAST_SNAPSHOT" "$SNAPSHOT_DIR"/"$SNAPSHOT_NAME" "|" ssh emil@10.0.0.1 "sudo btrfs receive /btrfs/"
    btrfs send -c "$SNAPSHOT_DIR"/"$LAST_SNAPSHOT" "$SNAPSHOT_DIR"/"$SNAPSHOT_NAME" | ssh "$REMOTE_USER"@"$REMOTE_HOST" "sudo btrfs receive /btrfs/"
    if [ $? -eq 0 ]; then
      echo $SNAPSHOT_NAME > "$SNAPSHOT_DIR"/"$NAME_PREFIX".last_sent
      ./clean_snapshots.sh $NAME_PREFIX
    else
      echo CRITICAL: Error while sending snapshot $SNAPSHOT_NAME
    fi
  else
    echo CRITICAL: No previous snapshot found for $NAME_PREFIX
  fi
}

send_snapshot $1
