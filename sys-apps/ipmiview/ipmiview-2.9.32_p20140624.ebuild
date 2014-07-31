# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# http://git.meleeweb.net/distros/gentoo/portage.git/tree/sys-apps/IPMIView/IPMIView-2.9.30.ebuild

EAPI=5
inherit java-utils-2

PN_UP="IPMIView"
PV_MAIN=${PV%%_*}
PV_PTCH=${PV##*_p}

DESCRIPTION="SuperMicro IPMI management tool"
HOMEPAGE="ftp://ftp.supermicro.com/utility/IPMIView"
SRC_URI="ftp://ftp.supermicro.com/utility/${PN_UP}/Jar/${PN_UP}_${PV_MAIN}_jar_${PV_PTCH}.zip"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

QA_PREBUILT="usr/lib*/*.so"

S="${WORKDIR}/${PN_UP}_${PV_MAIN}_jar_${PV_PTCH}"

src_install() {
	exeinto /usr/libexec
	doexe "${FILESDIR}/${PN}-wrapper"

	dosym "../libexec/${PN}-wrapper" /usr/bin/IPMIView20
	dosym "../libexec/${PN}-wrapper" /usr/bin/TrapReceiver

	java-pkg_dojar iKVM.jar IPMIView20.jar JViewerX9.jar TrapView.jar

	# Use LIBOPTIONS="-m0755" for bug #225729
	use x86   && LIBOPTIONS="-m0755" java-pkg_doso libiKVM32.so libSharedLibrary32.so
	use amd64 && LIBOPTIONS="-m0755" java-pkg_doso libiKVM64.so libSharedLibrary64.so

	dodoc IPMIView20.pdf IPMIViewSuperBlade.pdf ReleaseNote.txt
}
