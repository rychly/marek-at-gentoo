# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Front-end for the PSUTILS designed to work from all programs that uses CUPS"
HOMEPAGE="http://www.rastersoft.com/programas/gtkpsproc.html"
SRC_URI="http://www.rastersoft.com/descargas/unsuported/${P}.tar.bz2"

RESTRICT="mirror"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND=">=net-print/cups-1.1.23
	>=dev-python/pygtk-2.6.1
	>=app-text/psutils-1.17"
#	dev-python/gnome-applets-python
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-visor_failure.patch"

	mv "${S}/Makefile" "${S}/Makefile.orig"
	echo "D=${D}" > "${S}/Makefile"
	sed -r \
		-e 's/\/usr\//$(D)\/usr\//g' \
		-e '/if \[ -x \/etc\/init.d\/cups \];/,/fi/d' \
		-e '/cat warning.txt/,1d' \
		-e 's/lib\/cups/libexec\/cups/g' \
		"${S}/Makefile.orig" >> "${S}/Makefile"
}

src_install() {
	dodir /usr/bin /usr/share/pixmaps /usr/share/cups/model /usr/libexec/cups/backend
	cd "${S}"
	make install || die
}

pkg_postinst() {
	einfo ""
	einfo "The GTKPsProc virtual printer is now available."
	einfo "Use"
	einfo " lpadmin -p GtkPSproc -E -v psproc_backend:/ -m gtkpsproc"
	einfo "to install it. Remember to run the psproc_applet for each user"
	einfo "who will use GTKPsProc."
	einfo "Use"
	einfo " psproc_applet &"
	einfo "to do so."
	einfo ""
}
