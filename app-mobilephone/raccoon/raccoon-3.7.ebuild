# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 java-utils-2 eutils

DESCRIPTION="Google Play Desktop client to download apps from Google Play without a phone"
#SRC_URI="https://github.com/onyxbits/Raccoon/archive/v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/onyxbits/Raccoon.git"
HOMEPAGE="http://www.onyxbits.de/raccoon ${EGIT_REPO_URI}"

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

src_prepare() {
	mvn validate || die "Unable to prepare Maven environment!"
}

src_compile() {
	mvn package || die "Unable to build a JAR package!"
}

src_install() {
	# use jar without dependencies
	#local jar="target/${PN}-${PV}.jar"
	# use jar including dependencies
	local jar="target/${PN}-release-jar-with-dependencies.jar"
	java-pkg_newjar "${jar}" "${PN}${SLOT}.jar"
	java-pkg_dolauncher "${PN}${SLOT}" --jar "${PN}${SLOT}.jar"
	newicon "artwork/icon.svg" "${PN}${SLOT}.svg"
	make_desktop_entry "${PN}${SLOT}" "Raccoon ${SLOT}" "${PN}${SLOT}" "Network;Java" \
		"StartupWMClass=de.onyxbits.${PN}.App\nGenericName=Google Play Desktop client"
}
