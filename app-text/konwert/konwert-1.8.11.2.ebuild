# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

PV_MAJ=${PV%.*.*}
PV_MIN=${PV#*.*.}

DESCRIPTION="Charset conversion for files or terminal I/O"
HOMEPAGE="http://packages.qa.debian.org/konwert"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV_MAJ}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV_MAJ}-${PV_MIN}.diff.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV_MAJ}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${PN}_${PV_MAJ}-${PV_MIN}.diff" || die "Cannot patch!"
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
