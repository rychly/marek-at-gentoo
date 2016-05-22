# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Userspace software for usb aes2501 fingerprint scanner"
HOMEPAGE="http://packages.debian.org/sid/aes2501-wy"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV%.*}.orig.tar.gz
	mirror://debian/pool/main/a/${PN}/${PN}_${PV%.*}-${PV##*.}.diff.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
RESTRICT="mirror"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	sed "s/${PN}-${PV%.*}/${PN}/g" "${WORKDIR}/${PN}_${PV%.*}-${PV##*.}.diff" > "${WORKDIR}/${PN}_${PV%.*}-${PV##*.}-new.diff" || die "Unable to modify a patch!"
	epatch "${WORKDIR}/${PN}_${PV%.*}-${PV##*.}-new.diff" || die "Unable to patch a source!"
}

src_install() {
	dobin "${PN//-*/}" || die "Unable to install an executable binary!"
}
