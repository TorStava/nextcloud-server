#!/bin/bash

# Output colors
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"

#acd_cli vars
MOUNT_POINT="/var/srv/nextcloud/minimal/nextcloud/data_cli/"
ACD_PATH="acd:/nextcloud_wwwdata"

log() {
  echo "$BLUE > $1 $NORMAL"
}

error() {
  echo ""
  echo "$RED >>> ERROR - $1$NORMAL"
}

help() {
  echo "-----------------------------------------------------------------------"
  echo "                      Available commands                              -"
  echo "-----------------------------------------------------------------------"
  echo -e -n "$BLUE"
  echo "   > stop - To stop containers"
  echo "   > start - To start containers"
  echo "   > help - Display this help"
  echo -e -n "$NORMAL"
  echo "-----------------------------------------------------------------------"

}

start() {
  docker-compose up -d
}

stop() {
  docker-compose down
}

mount() {
  mkdir -p $MOUNT_POINT
  # acd_cli -nl mount --modules="subdir,subdir=$ACD_PATH" --uid $(id -u www-data) --gid $(id -g www-data) -fg -ao --umask 0007 -st $MOUNT_POINT
  rclone mount $ACD_PATH $MOUNT_POINT --log-level INFO --debug-fuse --uid $(id -u www-data) --gid $(id -g www-data) --allow-other --umask 0007
}

unmount() {
  fusermount -u $MOUNT_POINT
  if [ $? -ne 0 ]; then
    fusermount -u -z $MOUNT_POINT
  fi
}

#execute literal arguments
$@
