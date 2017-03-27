# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-utils-2 eutils
#inherit git-2

DESCRIPTION="Google Play Desktop client to download apps from Google Play without a phone"
SRC_URI="http://raccoon.onyxbits.de/sites/raccoon.onyxbits.de/files/raccoon-${PV}.jar"
EGIT_REPO_URI="https://github.com/onyxbits/raccoon4.git"
HOMEPAGE="http://raccoon.onyxbits.de/ ${EGIT_REPO_URI}"

if [[ "${PV}" != "9999" ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="${PV%%.*}"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-java/maven-bin-3.0"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

src_install() {
	java-pkg_newjar "${DISTDIR}/${A}" "${PN}${SLOT}.jar"
	java-pkg_dolauncher "${PN}${SLOT}" --jar "${PN}${SLOT}.jar"
	newicon "icons/appicon.png" "${PN}${SLOT}.png"
	make_desktop_entry "${PN}${SLOT}" "Raccoon ${SLOT}" "${PN}${SLOT}" "Network;Java" \
		"StartupWMClass=de.onyxbits.${PN}.Main\nGenericName=Google Play Desktop client"
}
