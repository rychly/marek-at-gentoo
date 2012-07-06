# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="easy way to install DLLs needed to work around problems in Wine"
HOMEPAGE="http://winetricks.org/"
SRC_URI=""
SRC_WEB="http://winetricks.googlecode.com/svn/trunk/src/winetricks"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	wget "${SRC_WEB}" -O "${PN}" || die
}

src_install() {
	dobin ${PN} || die
}
