#!/bin/bash

CONFIG=/etc/autofs-udev

## Check configuration
declare -A MOUNTOPTS MOUNTPOINTS
source "${CONFIG}"
if [ ! -d "${MOUNTPOINT_BASE}" -o ! -w "$(dirname '${AUTOFS_MAP}')" -o -z "${MOUNTOPTS[unknown]}" ]; then
	echo "Configuration error in '${CONFIG}'! Configuration file does not exists, MOUNTPOINT_BASE is not directory, AUTOFS_MAP directory is not writable, or MOUNTOPTS are not defined." >&2
	exit 1
fi

## Process udev events
# remove autofs map item
sed -i -e "/:${DEVNAME//\//\\/}\$/d" "${AUTOFS_MAP}"

# update of the maps for each mount point
killall -s HUP automount
