# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

## will be downloaded directly from the repository's web-server via HTTP, CVS not needed
#inherit cvs

DESCRIPTION="Goal of this project is to create system for searching in bus/train timetables."
HOMEPAGE="http://timetab.sourceforge.net/"
ECVS_SERVER="timetab.cvs.sourceforge.net:/cvsroot/timetab"
ECVS_USER="pserver"
ECVS_PASS="anonymous"
ECVS_MODULE="timetab"
MY_ECVS_WEB="http://timetab.cvs.sourceforge.net/viewvc/timetab/timetab"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	local MY_SRC_URI="
		${MY_ECVS_WEB}/Makefile
		${MY_ECVS_WEB}/timetab.c
		${MY_ECVS_WEB}/timetab.h
		${MY_ECVS_WEB}/exists.c
		${MY_ECVS_WEB}/heap.c
		${MY_ECVS_WEB}/travel.c
		${MY_ECVS_WEB}/itimetab.c
	"
	wget --directory-prefix="${WORKDIR}" ${MY_SRC_URI} || die "Cannot download source files from the repository!"
}

src_install() {
	dobin timetab travel itimetab
}
