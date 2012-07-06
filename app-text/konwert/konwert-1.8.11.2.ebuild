# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

VMAJ=$(echo ${PV} | cut -d. -f1-2)
VMIN=$(echo ${PV} | cut -d. -f3-)

DESCRIPTION="Charset conversion for files or terminal I/O"
HOMEPAGE="http://packages.qa.debian.org/konwert"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${VMAJ}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${VMAJ}-${VMIN}.diff.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
RESTRICT="mirror"

IUSE=""

S="${WORKDIR}/${PN}-${VMAJ}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${PN}_${VMAJ}-${VMIN}.diff" || die "Cannot patch!"
}

src_compile() {
	emake prefix=/usr || die "Cannot make!"
}

src_install() {
	local DEST=/usr
	dodir "${DEST}" "${DEST}/share"
	make install "prefix=${D}${DEST}" || die "Cannot install!"
	mv "${D}${DEST}/doc" "${D}${DEST}/man" "${D}${DEST}/share/"
}
