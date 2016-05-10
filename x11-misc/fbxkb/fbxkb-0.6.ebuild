# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="X11 keyboard indicator and switcher"
HOMEPAGE="http://freshmeat.net/projects/fbxkb/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="x11-libs/libX11
	>=x11-libs/gtk+-2.6
	x11-libs/pixman
	dev-libs/atk
	media-libs/libpng"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i 's/install -d $(PREFIX)\/bin/install -d $(DESTDIR)$(PREFIX)\/bin/' Makefile || die "Sed filed"
	sed -i 's/install -m 755 $(TARGET) $(PREFIX)\/bin/install -m 755 $(TARGET) $(DESTDIR)$(PREFIX)\/bin/' Makefile || die "Sed filed"
	sed -i 's/install -d  $(PREFIX)\/share\/fbxkb/install -d  $(DESTDIR)$(PREFIX)\/share\/fbxkb/' images/Makefile || die "Sed filed"
	sed -i 's/install -d  $(PREFIX)\/share\/fbxkb\/images/install -d  $(DESTDIR)$(PREFIX)\/share\/fbxkb\/images/' images/Makefile || die "Sed filed"
	sed -i 's/install -m 644 \*.png $(PREFIX)\/share\/fbxkb\/images\//install -m 644 \*.png $(DESTDIR)$(PREFIX)\/share\/fbxkb\/images\//' images/Makefile || die "Sed filed"
}

src_compile() {
	./configure --transparency || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc CREDITS INSTALL README
}
