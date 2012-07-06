# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_REPO_URI="https://svn.openwrt.org/openwrt/packages/"
ESVN_MODULE="openwrt-packages"

DESCRIPTION="Additional packages for OpenWrt."
HOMEPAGE="https://dev.openwrt.org/browser/packages"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"
SLOT="0"
IUSE=""
RDEPEND="net-misc/openwrt"

ANAME="${P}.`date +%F`"

src_unpack() {
	subversion_fetch
	mkdir "${WORKDIR}/package"
	for I in "${S}"/*/*; do
	    [ -d "${I}" ] && mv "${I}" "${WORKDIR}/package"
	    echo "${I}" | grep -o '[^/]*/[^/]*$' >>"${WORKDIR}/package/packages"
	done
}

src_compile() {
	cd "${WORKDIR}"
	tar -czf "${WORKDIR}/${ANAME}.tgz" package --exclude=.svn --exclude=.gitignore || die "Unable to pack!"
}

src_install() {
	dodir "/opt"
	mv "${WORKDIR}/${ANAME}.tgz" "${D}/opt/" || die "Unable to install!"
}
