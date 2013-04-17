# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Java application for sending SMS over the Internet using various mobile operator web gateways"
HOMEPAGE="http://code.google.com/p/esmska/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=virtual/jre-1.6"
DEPEND="!app-mobilephone/esmska"

src_install() {
	dobin "${FILESDIR}/${PN%-*}" "${FILESDIR}/${PN%-*}-gw-for-contacts" "${FILESDIR}/${PN%-*}-gw-for-number" || die "dobin failed"
	doicon "${FILESDIR}/${PN%-*}.png"
	make_desktop_entry "${PN%-*}" "Esmska" "${PN%-*}" "Network;InstantMessaging;Java"
}
