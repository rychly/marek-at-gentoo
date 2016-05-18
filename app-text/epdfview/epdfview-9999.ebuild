# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit subversion eutils

DESCRIPTION="Lightweight PDF viewer using Poppler and GTK+ libraries."
HOMEPAGE="http://trac.emma-soft.com/epdfview/"

ESVN_REPO_URI="svn://svn.emma-soft.com/epdfview/trunk"
ESVN_PROJECT="epdfview"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cups nls"

COMMON_DEPEND=">=virtual/poppler-glib-0.5.0[cairo]
	>=x11-libs/gtk+-2.6
	cups? ( >=net-print/cups-1.1 )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-util/cppunit )"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"

src_unpack() {
	subversion_src_unpack
	# We need to create the ChangeLog here
	TZ=UTC svn log -v "${ESVN_REPO_URI}" >./ChangeLog
}

src_prepare() {
	# Icon size
	sed -i -e 's:Icon=icon_epdfview-48:Icon=epdfview:' ./data/epdfview.desktop || die "desktop sed failed"
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with cups)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README THANKS ChangeLog
	for size in 24 32 48; do
		icnsdir="/usr/share/icons/hicolor/${size}x${size}/apps/"
		insinto "${icnsdir}" || die "insinto failed"
		newins "data/icon_epdfview-${size}.png" "epdfview.png" || die "newins failed"
	done
}
