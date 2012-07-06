# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="DWG to DXF is a command-line utility to convert DWG files to DXF files."
SRC_URI="mirror://sourceforge/lx-viewer/${P}.tar.gz"
HOMEPAGE="http://lx-viewer.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="sys-devel/gcc"
RESTRICT="mirror"

src_compile() {
	epatch "${FILESDIR}/initfilepath.patch" || die "unable to patch for init-file path"
	econf || die "econf failed"
	if use amd64; then
		sed 's/\(CPPFLAGS\|LDFLAGS\|dwg2dxf_LDFLAGS\|CXXFLAGS\) = /old_\1 = /g' ${S}/dwg2dxf/Makefile > ${S}/dwg2dxf/Makefile.new \
		&& mv ${S}/dwg2dxf/Makefile.new ${S}/dwg2dxf/Makefile || die "unable to prepare for 32-bit architecture"
		epatch "${FILESDIR}/m32_flags.patch" || die "unable to patch for 32-bit architecture"
	fi
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "installation failed"
	insinto "/usr/share/${PN}"
	doins "${S}/dwg2dxf/adinit.dat" || die "unable to install adinit.dat"
	dodoc INSTALL README COPYING AUTHORS
}