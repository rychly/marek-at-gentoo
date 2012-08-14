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
if [ \
	\( "${ID_FS_USAGE}" = "filesystem" \) -a \
	\( \( "${ACTION}" = "add" -a "${DEVTYPE}" = "partition" \) -o \( "${ACTION}" = "change" -a "${DEVTYPE}" = "disk" \) \) \
]; then

	# skip if already processed, or to be mounted manually by fstab entry
	grep -q ":${DEVNAME}\$" "${AUTOFS_MAP}" && exit 0
	grep -q "^\\(${DEVNAME}\\|LABEL=${ID_FS_LABEL_ENC}\\|UUID=${ID_FS_UUID_ENC}\\)" /etc/fstab && exit 0

	# obtain or assign unique mountpoint
	# TODO: obtain mountpoint as predefined in the configuration file
	MOUNTPOINT="$(basename ${DEVNAME})"
	if [ -n "${ID_FS_LABEL}" ]; then
		MOUNTPOINT+=".${ID_FS_LABEL// /_}"
	elif [ -n "${ID_FS_UUID_ENC}" ]; then
		MOUNTPOINT+=".${ID_FS_UUID_ENC}"
	fi

	# obtain mounting options
	if [ -z "${MOUNTOPTS[$ID_FS_TYPE]}" ]; then
		OPTIONS="${MOUNTOPTS[unknown]}"
	else
		OPTIONS="${MOUNTOPTS[$ID_FS_TYPE]}"
	fi

	# add autofs map item
	echo "${MOUNTPOINT} ${OPTIONS} :${DEVNAME}" >>"${AUTOFS_MAP}"

	# update of the maps for each mount point
	killall -s HUP automount
fi
