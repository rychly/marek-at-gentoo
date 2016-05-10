# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PV_SUFFIX=-kb

inherit cmake-utils vcs-snapshot

DESCRIPTION="Keith Bennett's port of KeePassX + keepasshttp + autotype"
HOMEPAGE="https://github.com/keithbennett/keepassx"
SRC_URI="https://github.com/keithbennett/${PN%%-kb}/archive/${PV/_/-}${PV_SUFFIX}.tar.gz -> ${P}${PV_SUFFIX}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="mirror"

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
	!app-admin/keepassx-sf
	net-libs/libmicrohttpd
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}${PV_SUFFIX}"
DOCS=(CHANGELOG)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
	)
	cmake-utils_src_configure
}
