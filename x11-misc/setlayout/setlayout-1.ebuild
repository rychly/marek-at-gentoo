# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A small program to set X11 desktop layout."
HOMEPAGE="http://openbox.org/wiki/Help%3aFAQ#How_do_I_put_my_desktops_into_a_grid_layout_instead_of_a_single_row.3F"
SRC_URI="http://openbox.org/dist/tools/setlayout.c"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"

RDEPEND="x11-libs/libX11"

DEPEND="${RDEPEND}"

src_unpack() {
	echo NOP >/dev/null
}

src_compile() {
	gcc ${CFLAGS} "${DISTDIR}/${A}" -o "${PN}" -lX11 || die "Unable to compile!"
}

src_install() {
	exeinto /usr/bin
	doexe "${PN}" || die "Unable to install!"
}
