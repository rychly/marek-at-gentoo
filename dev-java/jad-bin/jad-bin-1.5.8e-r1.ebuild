# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Jad - The fast JAva Decompiler"
HOMEPAGE="https://web.archive.org/web/20080214075546/http://www.kpdus.com/jad.html"
SRC_URI="https://web.archive.org/web/20080214075546/http://www.kpdus.com/jad/linux/jadls158.zip"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="freedist"
IUSE=""
RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	into /opt
	dobin jad || die "dobin failed"
	dodoc Readme.txt || die "dodoc failed"
}
