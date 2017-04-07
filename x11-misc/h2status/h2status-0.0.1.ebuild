# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Simple i3status bash wrapper with json, mouse events and asynchronous update support."
HOMEPAGE="https://wiki.archlinux.org/index.php/H2status https://gist.github.com/memeplex/8115385"
SRC_URI="https://gist.githubusercontent.com/memeplex/8115385/raw/ceaf47ca4b6ffc0947447a201f6b24bca60dd487/h2status
	https://gist.githubusercontent.com/memeplex/8115385/raw/ceaf47ca4b6ffc0947447a201f6b24bca60dd487/h2statusrc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"
IUSE="+doc"

RDEPEND="app-shells/bash
	x11-misc/i3status"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${PN}" "${DISTDIR}/${PN}rc" "${S}"
}

src_prepare() {
	sed -i "s|^tmp=.*\$|tmp=/run/user/\${UID}/${PN}_|"  "${PN}"
}

src_install() {
	dobin "${PN}" || die "Unable to install the executable!"
	if use doc; then
		dodoc "${PN}rc" || die "Unable to install a sample configuration file!"
	fi
}
