# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git-2 eutils autotools fdo-mime

DESCRIPTION="LaTeX editor based on Bluefish"
HOMEPAGE="http://viettug.github.com/winefish/"

EGIT_REPO_URI="git://github.com/viettug/${PN} http://github.com/viettug/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="spell"

RDEPEND=">=x11-libs/gtk+-2.4
	>=dev-libs/libpcre-6.3
	spell? ( virtual/aspell-dict )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/configure-man.patch"
	epatch "${FILESDIR}/makefile-doc.patch"
	epatch "${FILESDIR}/winefish-nostrip.patch"
	eautoconf --force
}

src_configure() {
	chmod +x "${S}/configure"
	econf --disable-update-databases
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS CHANGES README ROADMAP THANKS TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	elog "You need to emerge a TeX distribution to gain winfish's full capacity"
}
