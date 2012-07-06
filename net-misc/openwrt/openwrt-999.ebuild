# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_REPO_URI="https://svn.openwrt.org/openwrt/trunk/"
ESVN_MODULE="openwrt"

DESCRIPTION="OpenWrt is described as a Linux distribution for embedded devices."
HOMEPAGE="http://openwrt.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

ANAME="${P}.`date +%F`"

src_compile() {
	cd "${WORKDIR}"
	tar -czf "${WORKDIR}/${ANAME}.tgz" ${P} --exclude=.svn --exclude=.gitignore || die "Unable to pack!"
}

src_install() {
	dodir "/opt"
	mv "${WORKDIR}/${ANAME}.tgz" "${D}/opt/" || die "Unable to install!"
}
