# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Enable fast charging of devices connected via USB ports."

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_compile() {
	gcc -Wall -Wextra ${FILESDIR}/usbfastcharger.c -lusb-1.0 -o ${WORKDIR}/${PN} \
	|| die 'Cannot compile the source file!'
}

src_install() {
	dobin "${PN}" \
	|| die "Unable to install an executable binary!"
}
