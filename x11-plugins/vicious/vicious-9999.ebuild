# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2

DESCRIPTION="Modular widget library for x11-wm/awesome"
HOMEPAGE="http://awesome.naquadah.org/wiki/Vicious"
SRC_URI=""

EGIT_REPO_URI="http://git.sysphere.org/vicious/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-wm/awesome"

src_install() {
	insinto /usr/share/awesome/lib/vicious
	doins -r widgets helpers.lua init.lua || die "Install failed"
	dodoc CHANGES README TODO || die "dodoc failed"
}
