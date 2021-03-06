# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Network address and service translation call with IPPROTO_TCP ai_protocol"
HOMEPAGE="https://en.wikipedia.org/wiki/Getaddrinfo"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

src_compile() {
	gcc "${FILESDIR}/getaddrinfo-tcp.c" -o "${WORKDIR}/${PN}" || die 'Cannot compile the source file!'
}

src_install() {
	dobin "${PN}" || die "Unable to install an executable binary!"
}
