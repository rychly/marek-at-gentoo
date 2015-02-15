#!/bin/sh

VER_FROM="${1}"
VER_TO="${2}"
DIR=$(dirname "${0}")

NAME_VP="dev-util/vp-bin"
NAME_VPCE="dev-util/vp-ce-bin"
MANIFEST_VP="${DIR}/../${NAME_VP}/Manifest"
MANIFEST_VPCE="${DIR}/../${NAME_VPCE}/Manifest"
EBUILD_VP="${DIR}/../${NAME_VP}/${NAME_VP#*/}-%s.ebuild"
EBUILD_VPCE="${DIR}/../${NAME_VPCE}/${NAME_VPCE#*/}-%s.ebuild"

EBUILD_VP_FROM=$(printf "${EBUILD_VP}" "${VER_FROM}")
EBUILD_VP_TO=$(printf "${EBUILD_VP}" "${VER_TO}")
EBUILD_VPCE_FROM=$(printf "${EBUILD_VPCE}" "${VER_FROM}")
EBUILD_VPCE_TO=$(printf "${EBUILD_VPCE}" "${VER_TO}")

if [[ "${1}" == "--help" || -z "${VER_FROM}" || -z "${VER_TO}" \
	|| ! ( -e "${EBUILD_VP_FROM}" || -e "${EBUILD_VPCE_FROM}" ) ]]; then
	echo "Usage: ${0} <original-full-version> <new-full-version>" >&2
	echo "Migrates ${NAME_VP} and ${NAME_VPCE} ebuilds from the original to the new full version." >&2
	exit -1
fi

function upgrade() {
	EBUILD_FROM="${1}"
	EBUILD_TO="${2}"
	MANIFEST="${3}"
	cp -v "${EBUILD_FROM}" "${EBUILD_TO}"
	ebuild "${EBUILD_TO}" manifest
	echo "The changes will be registered into GIT. Abort by Ctrl+C or press Enter to continue."
	read
	git rm "${EBUILD_FROM}"
	ebuild "${EBUILD_TO}" manifest
	git add "${EBUILD_TO}" "${MANIFEST}"
}

[[ -e "${EBUILD_VP_FROM}" ]] \
	&& upgrade "${EBUILD_VP_FROM}" "${EBUILD_VP_TO}" "${MANIFEST_VP}"

[[ -e "${EBUILD_VPCE_FROM}" ]] \
	&& upgrade "${EBUILD_VPCE_FROM}" "${EBUILD_VPCE_TO}" "${MANIFEST_VPCE}"
