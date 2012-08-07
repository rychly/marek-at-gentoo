# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

DESCRIPTION="Wuala, your free online hard-disk"
HOMEPAGE="http://wuala.com/"
SRC_URI="http://cdn.wuala.com/repo/other/wuala.tar.gz"

LICENSE="wuala"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-fs/fuse
	>=virtual/jre-1.5.0"

S="${WORKDIR}/${PN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	sed -i "s|-jar |-jar ${INSTALLDIR}/|" "${S}/wuala"
	sed -i "s|\\./wuala|${INSTALLDIR}/wuala|" "${S}/wualacmd"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/loader3.jar" "${S}/wuala" "${S}/wualacmd" "${D}/${INSTALLDIR}"
	dodoc copyright readme.txt
	dodir "/etc/env.d"
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
