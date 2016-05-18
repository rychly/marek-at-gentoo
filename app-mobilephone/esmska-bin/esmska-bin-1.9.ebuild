# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit java-utils-2 eutils

MYP="${P//-bin/}"
MYPN="${PN//-bin/}"

DESCRIPTION="A program for sending SMS over the Internet"
HOMEPAGE="https://code.google.com/p/esmska/"
#SRC_URI="http://esmska.googlecode.com/files/${MYP}.tar.gz"
SRC_URI="http://ripper.profitux.cz/esmska/packages/${MYP}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MYP}"
INSTALLDIR="/opt/${PN}"

src_prepare() {
	rm "${S}"/esmska.{exe,sh}
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/{gateways,icons,lib} "${S}"/esmska.{conf,jar} "${D}${INSTALLDIR}" || die "Cannot install needed files"

	java-pkg_regjar "${D}${INSTALLDIR}/lib"/*.jar "${D}${INSTALLDIR}/esmska.jar"
	# Disable IPv6 because it breaks Java networking on Ubuntu and Debian
	# http://code.google.com/p/esmska/issues/detail?id=252 http://code.google.com/p/esmska/issues/detail?id=233
	java-pkg_dolauncher "${MYPN}" \
		--jar esmska.jar \
		--java_args "-Djava.net.preferIPv4Stack=true" \
		--pwd "${INSTALLDIR}"

	make_desktop_entry "${MYPN}" "Esmska" "${INSTALLDIR}/icons/esmska.png" "Network;InstantMessaging;Java" \
		"StartupWMClass=esmska-Main\nGenericName=SMS Sender"

	dodoc "${S}/license"/*.txt "${S}/readme.txt"
}
