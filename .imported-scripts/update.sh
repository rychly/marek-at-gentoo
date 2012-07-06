#!/bin/sh

if [ `whoami` != "portage" ]; then
	[ "$1" == "--rerun" ] && exit 1
	exec sudo -u portage $0 --rerun $@
fi; [ "$1" == "--rerun" ] && shift

DOT=$(dirname $0)/.$(basename $0) CFG=${DOT//.sh/.cfg}
if [ -f "${CFG}" ]; then
	. "${CFG}"
else
	echo "Cannot read configuration from file ${CFG}" >&2
	exit 1
fi

update() {
	# config
	while [ -n "$1" ]; do
		echo "processing option '$1' ..." >&2
		case "$1" in
			"--nosvn")	NO_SVN=1;;
			"--norsync")	NO_RSYNC=1;;
			"--noscript")	NO_SCRIPT=1;;
			*)		echo "Unknown option '$1'" >&2; exit 2
		esac
		shift
	done
	# SVN
	[ -z "${NO_SVN}" -a -n "$SVN_PROJECTS" ] && echo $SVN_PROJECTS | tr ' ' '\n' \
	| while read PROJ; do
		echo "${UV} Subversion: ${PROJ} ${UV}"
		[ -d "${DIR}/${PROJ}" ] && \
		svn up "${DIR}/${PROJ}" \
		|| echo "Error $?" >&2
	done
	# Rsync
	[ -z "${NO_RSYNC}" -a -n "$RSYNC_PROJECTS" ] && echo $RSYNC_PROJECTS | tr ' ' '\n' \
	| while read PROJ; do
		echo "${UV} Rsync: ${PROJ} ${UV}"
		[ -f "${DIR}/${PROJ}/${RSYNC_CFG}" ] && \
		rsync \
		--recursive --links --safe-links --perms --times --compress --force --delete --delete-after --progress --stats --timeout=10 \
		"--exclude=${RSYNC_CFG}" "--filter=H_**/files/digest-*" `head -1 ${DIR}/${PROJ}/${RSYNC_CFG}` "${DIR}/${PROJ}" \
		|| echo "Error $?" >&2
	done
	# Shell Scripts
	[ -z "${NO_SCRIPT}" -a -d "$(dirname $0)/$SCRIPT_PROJECTS" ] && for PROJ in "$(dirname $0)/${SCRIPT_PROJECTS}"/*; do
		echo "${UV} Script: ${PROJ} ${UV}"
		. $PROJ \
		|| echo "Error $?" >&2
	done
}

case "$1" in
	"--help")
		echo "Usage:	$0 [OPTION]"
		echo "Update local overlay from various sources."
		echo
		echo "Options:"
		echo "	--help		display this help and exit"
		echo "	--list		display list of updated packages"
		echo "	--nosvn		don't synchronize overlay's packages from Subversion"
		echo "	--norsync	don't synchronize overlay's packages from Rsync"
		echo "	--noscript	don't synchronize overlay's packages via shell scripts"
		echo
		echo "Report bugs to <marek.rychly@gmail.com>."
	;;
	"--list")
		echo "${UV} Subversion ${UV}"
		echo "${SVN_PROJECTS}"
		echo "${UV} Rsync ${UV}"
		echo "${RSYNC_PROJECTS}"
		echo "${UV} Shell Scripts ${UV}"
		grep -R '^##' "$(dirname $0)/${SCRIPT_PROJECTS}"
	;;
	*)
		update $@
esac
