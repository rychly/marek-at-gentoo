# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://www.keepassx.org/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}"

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

DOCS=(CHANGELOG)

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
