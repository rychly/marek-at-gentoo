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

src_unpack() {
	local MY_SRC_URI=$(wget "${EDARCS_REPOSITORY}" -O - | grep -o '[^"]*/browse/[^"]*' | sed 's:/browse/:/raw/:g' | tr '\n' ' ')
	[ $? -ne 0 ] && die "Cannot download a list of files in the repository!"
	wget --directory-prefix="${WORKDIR}" ${MY_SRC_URI} || die "Cannot download source files from the repository!"
}

src_prepare() {
	vala_src_prepare
	sed -i \
		-e 's:^\(XML *= *\).*$:\1/usr/share/dbus-1/interfaces/kbdd-service-interface.xml:' \
		-e "s:^\(VALAC *= *\).*\$:\1${VALAC}:" \
		"${WORKDIR}/Makefile"
}

src_install() {
	dobin kbdd_tray_companion
	dodoc LICENSE README
	make_desktop_entry "kbdd_tray_companion" "KBDD tray companion" "preferences-desktop-keyboard" "System"
}
