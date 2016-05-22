# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="Video stabilizer for CCD and CMOS cameras (MJPEG videos)."
HOMEPAGE="http://vstab.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}.zip"

# v?: 2014-04-16

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="virtual/jpeg"
RDEPEND=""

S=${WORKDIR}/${PN}

src_install() {
	exeinto /usr/bin
	doexe "${S}/vstab" || die 'Installation failed'
}
