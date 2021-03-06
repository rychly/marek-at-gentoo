# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Configuration tool for RouterOS"
HOMEPAGE="http://wiki.mikrotik.com/wiki/Manual:Winbox"

SLOT="0"
KEYWORDS="x86 amd64"
LICENSE="proprietary-unspecified"

DEPEND=""
RDEPEND="virtual/wine"

src_unpack() {
	cp --dereference "${FILESDIR}/${PN}.png" "${WORKDIR}"
	wget -O "${WORKDIR}/${PN}.exe" "http://download2.mikrotik.com/winbox.exe" || die "Unable to fetch!"
	chmod 755 "${WORKDIR}/${PN}.exe"
}

src_install() {
	local INSTALLDIR="/opt/mikrotik"
	dodir "${INSTALLDIR}"
	mv "${WORKDIR}"/* "${D}/${INSTALLDIR}"
	make_desktop_entry "/usr/bin/wine ${INSTALLDIR}/${PN}.exe" "Mikrotik's Winbox" "${INSTALLDIR}/${PN}.png" "Network;RemoteAccess"
}
