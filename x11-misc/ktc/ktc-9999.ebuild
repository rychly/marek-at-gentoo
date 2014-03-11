# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit vala eutils

## will be downloaded directly from the repository's web-server via HTTP, DARCS not needed
#inherit darcs

DESCRIPTION="System tray companion for kbdd."
HOMEPAGE="http://hub.darcs.net/zabbal/ktc"
EDARCS_REPOSITORY="http://hub.darcs.net/zabbal/${PN}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="x11-misc/kbdd[dbus]
	sys-apps/dbus"
DEPEND="${RDEPEND}
	net-misc/wget
	dev-lang/vala
	x11-libs/libnotify
	dev-libs/dbus-glib
	dev-util/vala-dbus-binding-tool"

darcsden_download() {
	local SRC="${1}"
	local DST="${2}"
	echo "Fetching ${SRC} into ${DST} ..."
	local URLS=$(wget "${SRC}" -O - | \
		grep -o 'class="\(directory\|file\)"\|[^"]*/browse/[^"]*' | \
		tr '\n' ' ' | \
		sed 's/class="\([^"]\)[^"]*" \([^ ]*\) /\1|\2\n/g' \
	)
	[[ $? -eq 0 ]] || return -1
	mkdir -p "${DST}"
	for I in ${URLS}; do
		local TYPE="${I:0:1}"
		local URL="${I:2}"
		if [[ "${TYPE}" == 'f' ]]; then
			wget --directory-prefix="${DST}" "${URL//\/browse\///raw/}" || return -2
		elif [[ "${TYPE}" == 'd' ]]; then
			darcsden_download "${URL}/" "${DST}/$(basename ${URL})"
			[[ $? -eq 0 ]] || return $?
		fi
	done
	return 0
}

src_unpack() {
	darcsden_download "${EDARCS_REPOSITORY}" "${WORKDIR}" || die "Cannot download source files from the repository!"
}

src_prepare() {
	vala_src_prepare
	sed -i \
		-e 's:^\(XML *= *\).*$:\1/usr/share/dbus-1/interfaces/kbdd-service-interface.xml:' \
		-e "s:^\(VALAC *= *\).*\$:\1${VALAC}:" \
		-e 's:^\(VALACOPTS *=.*\) --fatal-warnings \(.*\)$:\1 \2:' \
		"${WORKDIR}/Makefile"
}

src_install() {
	dobin kbdd_tray_companion
	dodoc LICENSE README
	make_desktop_entry "kbdd_tray_companion" "KBDD tray companion" "preferences-desktop-keyboard" "System"
}
