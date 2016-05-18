# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A perl-based utility to convert Ms Office Docx to equivalent text documents"
HOMEPAGE="http://docx2txt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="dev-lang/perl"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	make BINDIR="${D}/usr/bin" CONFIGDIR="${D}/etc" install || die
}
