# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit git-2

DESCRIPTION="Open source toolset for for handling Allwinner A10 firmware images."
HOMEPAGE="https://github.com/Ithamar/awutils"

EGIT_REPO_URI="https://github.com/Ithamar/${PN} git://github.com/Ithamar/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

src_install() {
	dobin awflash awimage log2bin
	dodoc README
}
