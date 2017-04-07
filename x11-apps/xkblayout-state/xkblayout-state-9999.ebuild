# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit git-2

DESCRIPTION="A small command-line program to get/set the current keyboard layout."
HOMEPAGE="https://github.com/nonpop/xkblayout-state"
#SRC_URI="https://github.com/nonpop/${PN}/archive/v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/nonpop/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+doc"

DEPEND="x11-libs/libX11"
RDEPEND=""

src_install() {
	dobin "${PN}"
	use doc && dodoc README.md
}
