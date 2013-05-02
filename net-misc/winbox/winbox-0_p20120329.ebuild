# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Configuration tool for RouterOS"
HOMEPAGE="http://wiki.mikrotik.com/wiki/Manual:Winbox"
# the unversioned download, patch level set to Last-Modified as it has been get by curl -I <URI>
SRC_URI="http://download2.mikrotik.com/winbox.exe -> ${P}.exe"

SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"

DEPEND=""
RDEPEND="app-emulation/wine"

INSTALLDIR="/opt/mikrotik"

src_unpack() {
	# no unpacking, just copy
	mkdir -p "${S}"
	cp --dereference "${DISTDIR}/${A}" "${FILESDIR}/${PN}.png" "${S}"
	# make executable
	mv "${S}/${P}.exe" "${S}/${PN}.exe"
	chmod 755 "${S}/${PN}.exe"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}"
	make_desktop_entry "/usr/bin/wine ${INSTALLDIR}/${PN}.exe" "Mikrotik's Winbox" "${INSTALLDIR}/${PN}.png" "Network;RemoteAccess"
}