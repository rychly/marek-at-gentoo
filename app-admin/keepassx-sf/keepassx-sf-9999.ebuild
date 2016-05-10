# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Surefire's port of KeePassX + keepasshttp + autotype"
HOMEPAGE="https://github.com/repsac-by/keepassx"
EGIT_REPO_URI="https://github.com/repsac-by/${PN%%-sf}.git"

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/qjson
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	!app-admin/keepassx
	!app-admin/keepassx-kb
	net-libs/libmicrohttpd
	sys-auth/oath-toolkit
"
RDEPEND="${DEPEND}"

DOCS=(CHANGELOG)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
	)
	cmake-utils_src_configure
}
