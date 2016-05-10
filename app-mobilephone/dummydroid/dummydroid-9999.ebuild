# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 java-utils-2 eutils

DESCRIPTION="Dummy Droid allows you to create hardware profiles for arbitrary Android devices and upload them into your Google Play account."
#SRC_URI="https://github.com/onyxbits/dummydroid/archive/v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/onyxbits/dummydroid.git"
HOMEPAGE="http://www.onyxbits.de/dummydroid ${EGIT_REPO_URI}"

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
	local jar=$(ls target/DummyDroid-*.jar | head -1)
	java-pkg_newjar "${jar}" "${PN}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar"
	#newicon "artwork/icon.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "Dummy Droid" "${PN}" "Network;Java" \
		"StartupWMClass=de.onyxbits.${PN}.App"
}
