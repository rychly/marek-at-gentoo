# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Video stabilizer for CCD and CMOS cameras (MJPEG videos)."
HOMEPAGE="http://vstab.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}.zip"

# v?: 2014-04-16

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="nomirror"

DEPEND="virtual/jpeg"

S=${WORKDIR}/${PN}

src_install() {
	exeinto /usr/bin
	doexe ${S}/vstab || die 'Installation failed'
}
