# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="A script with built-in list of online TV streams."
HOMEPAGE="http://xpisar.wz.cz/"
SRC_URI="http://xpisar.wz.cz/televize/televize-${PV}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 amd64-fbsd sparc-fbsd x86-fbsd" # the same as for app-shells/bash
IUSE="+ctstream"

RDEPEND="ctstream? ( media-video/ctstream )
	app-shells/bash"

DEPEND="${RDEPEND}"

src_install() {
	exeinto "/usr/bin"
	newexe "${DISTDIR}/${A}" "${PN}" || die "Cannot install the script!"
}
