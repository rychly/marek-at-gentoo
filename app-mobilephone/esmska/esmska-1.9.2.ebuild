# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A program for sending SMS over the Internet"
HOMEPAGE="https://github.com/kparal/esmska"
SRC_URI="https://github.com/kparal/${PN}/archive/v${PV}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="!app-mobilephone/esmska-bin"
RDEPEND=">=virtual/jre-1.6"

INSTALLDIR="/opt/${PN}"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/dist/{gateways,icons,lib} "${S}"/dist/${PN}.{conf,jar} "${D}${INSTALLDIR}" || die "Cannot install needed files"

	java-pkg_regjar "${D}${INSTALLDIR}/lib"/*.jar "${D}${INSTALLDIR}/${PN}.jar"
	# Disable IPv6 because it breaks Java networking on Ubuntu and Debian
	# http://code.google.com/p/esmska/issues/detail?id=252 http://code.google.com/p/esmska/issues/detail?id=233
	java-pkg_dolauncher "${PN}" \
		--jar ${PN}.jar \
		--java_args "-Djava.net.preferIPv4Stack=true" \
		--pwd "${INSTALLDIR}"

	make_desktop_entry "${PN}" "Esmska" "${INSTALLDIR}/icons/${PN}.png" "Network;InstantMessaging;Java" \
		"StartupWMClass=${PN}-Main\nGenericName=SMS Sender"

	use doc && dodoc "${S}/license"/*.txt "${S}/readme.txt"
}
