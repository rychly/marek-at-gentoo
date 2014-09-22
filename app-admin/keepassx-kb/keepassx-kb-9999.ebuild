# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Keith Bennett's port of KeePassX + keepasshttp + autotype, a Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="https://github.com/keithbennett/keepassx"
EGIT_REPO_URI="https://github.com/keithbennett/${PN%%-kb}.git"

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	!app-admin/keepassx
	net-libs/libmicrohttpd
"
RDEPEND="${DEPEND}"

DOCS=(CHANGELOG)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
	)
	cmake-utils_src_configure
}
