# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

PV_MAJOR="${PV%%.*}"
PV_MINOR="${PV#*.}"

DESCRIPTION="3D/2D CAD software primarily intended for mechanical engineering design"
HOMEPAGE="http://www.varicad.cz/en/home/products/description/"
SRC_URI_BASE="http://www.varicad.cz/userdata/files/release"
SRC_URI="linguas_cs? (
		x86? ( ${SRC_URI_BASE}/cz/varicad${PV_MAJOR}-cz_${PV_MINOR}_i386.deb )
		amd64? ( ${SRC_URI_BASE}/cz/varicad${PV_MAJOR}-cz_${PV_MINOR}_amd64.deb )
	)
	!linguas_cs? ( linguas_de? (
		x86? ( ${SRC_URI_BASE}/de/varicad${PV_MAJOR}-de_${PV_MINOR}_i386.deb )
		amd64? ( ${SRC_URI_BASE}/de/varicad${PV_MAJOR}-de_${PV_MINOR}_amd64.deb )
	) )
	!linguas_cs? ( !linguas_de? ( linguas_pt? (
		x86? ( ${SRC_URI_BASE}/pt/varicad${PV_MAJOR}-pt_${PV_MINOR}_i386.deb )
		amd64? ( ${SRC_URI_BASE}/pt/varicad${PV_MAJOR}-pt_${PV_MINOR}_amd64.deb )
	) ) )
	!linguas_cs? ( !linguas_de? ( !linguas_pt? (
		x86? ( ${SRC_URI_BASE}/en/varicad${PV_MAJOR}-en_${PV_MINOR}_i386.deb )
		amd64? ( ${SRC_URI_BASE}/en/varicad${PV_MAJOR}-en_${PV_MINOR}_amd64.deb )
	) ) )"

LICENSE="proprietary-unspecified"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="linguas_en linguas_cs linguas_de linguas_pt"
RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	tar -xzf "${WORKDIR}/data.tar.gz" || tar -xJf "${WORKDIR}/data.tar.xz"
}

# it has fixed path (/opt/VariCAD/{bin,lib}) in binaries
INSTALLDIR="/opt/VariCAD"

src_install() {
	mv opt "${D}/" || die "Cannot install files"
	dodoc "usr/share/doc/varicad${PV_MAJOR}"-??/*
	dodir /usr/bin
	dosym "${INSTALLDIR}/bin/varicad" /usr/bin/varicad
	# license
	touch "${D}/opt/VariCAD/lib/varicad.lck"
	fperms a+rw /opt/VariCAD/lib/varicad.lck
	einfo
	einfo "VariCAD has been installed as a free trial version (just like the full version for a period of 30 days)."
	einfo "If you have already purchased a VariCAD license, copy its licence file varicad.lck into ${INSTALLDIR}/lib/"
	einfo
}
