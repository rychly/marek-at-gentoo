# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# based on https://data.gpo.zugaina.org/nixphoeni/www-client/brave-bin/brave-bin-0.12.0.ebuild

EAPI=5

inherit eutils

MY_PN="${PN%-bin}"
MY_PV="${PV%_rc*}dev"
PVRC="${PV##*_rc}"
[ "${PV}" != "${PVRC}" ] && MY_PV+="-Preview${PVRC}"

DESCRIPTION="Brave browser automatically blocks ads and trackers, making it faster and safer than your current browser."
HOMEPAGE="https://www.brave.com"
SRC_URI="https://github.com/${MY_PN}/browser-laptop/releases/download/v${MY_PV}/Brave.tar.bz2 -> ${P}.tar.bz2"

KEYWORDS="~amd64"

LICENSE="MPL-2.0"
SLOT="0"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-base/libgnome-keyring"
DEPEND="${RDEPEND}"

S="${WORKDIR}/Brave-linux-x64"

src_install() {
	insinto "/usr/share/${MY_PN}"
	doins version *.pak *.bin *.dat
	doins lib*.so

	doins -r resources locales

	exeinto "/usr/share/${MY_PN}"
	doexe "${MY_PN}"
	dosym "/usr/share/${MY_PN}/${MY_PN}" "/usr/bin/${MY_PN}"

	newicon -s 256 "${FILESDIR}/${MY_PN}.png" "${MY_PN}.png"

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # chromium bug #360797
	mime_types+="x-scheme-handler/ftp;" # chromium bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # chromium bug #416393
	make_desktop_entry "${MY_PN}" "Brave" "${MY_PN}" "Network;WebBrowser" "MimeType=${mime_types}"
	sed -e "/^Exec/s/$/ %U/" -i "${D}usr/share/applications"/*.desktop || die
}
