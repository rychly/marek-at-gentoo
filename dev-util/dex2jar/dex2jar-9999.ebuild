# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="Tools to work with android .dex and java .class files"
#SRC_URI="https://github.com/pxb1988/${PN}/archive/v${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/pxb1988/${PN}.git"
HOMEPAGE="${EGIT_REPO_URI%.git}"

EGIT_BRANCH="2.x"
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

#S="${WORKDIR}"

src_prepare() {
	mvn validate || die "Unable to prepare Maven environment"
}

src_compile() {
	mvn package -Dmaven.test.skip=true || die "Unable to build a JAR package"
}

src_install() {
	local INSTALL_DIR="/opt/${PN}"
	unzip dex-tools/target/dex2jar-*.zip -d target || die "Unable to unpack a distribution archive"
	chmod 755 target/dex2jar-*/*.sh
	dodir "${INSTALL_DIR}"
	mv target/dex2jar-*/*.txt target/dex2jar-*/*.sh target/dex2jar-*/lib "${D}${INSTALL_DIR}" || die "Unable to install files"
	for I in "${D}${INSTALL_DIR}"/d2j-*.sh; do
		I="${I##*/}"
		dosym "${INSTALL_DIR}/${I}" "/usr/bin/${I%.sh}"
	done
}
