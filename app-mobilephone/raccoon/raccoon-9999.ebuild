# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 java-utils-2 eutils

DESCRIPTION="Raccoon is a Google Play Desktop client that allows you to download apps directly from Google Play without you having to give Google control over your phone."
#SRC_URI="https://github.com/onyxbits/Raccoon/archive/v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/onyxbits/Raccoon.git"
HOMEPAGE="http://www.onyxbits.de/raccoon ${EGIT_REPO_URI}"

if [[ "${PV}" != "9999" ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
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
	java-pkg_newjar "${jar}" "${PN}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar"
	newicon "artwork/icon.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "Raccoon" "${PN}" "Network;Java" \
		"StartupWMClass=de.onyxbits.${PN}.App\nGenericName=Google Play Desktop client"
}
