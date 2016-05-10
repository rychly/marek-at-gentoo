# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit git-2 systemd

DESCRIPTION="A linux client for the MEGA cloud storage provider based on FUSE."
HOMEPAGE="https://github.com/matteoserva/MegaFuse"
EGIT_REPO_URI="https://github.com/matteoserva/MegaFuse.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/crypto++
	net-misc/curl
	sys-libs/db:4.8
	media-libs/freeimage
	sys-libs/readline
	sys-fs/fuse"

RDEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's|\(INCLUDES\s*=.*\)$|\1 -I /usr/include/db4.8|g' Makefile
	#sed -i 's|#include <db_cxx\.h>|#include <db4.8/db_cxx.h>|g' sdk/*.cpp src/*.cpp
}

src_install() {
	dobin MegaFuse
	dodoc FAQ.txt LICENSE.txt README.md megafuse.conf
	systemd_dounit "${PN}.service" "${PN}@.service"
}
