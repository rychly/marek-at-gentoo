# Copyright 1999-2017 Gentoo Foundation
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

RDEPEND="|| ( virtual/jre virtual/jdk )"

#S="${WORKDIR}"

src_compile() {
	${S}/gradlew || die "Unable to build a JAR package"
}

src_install() {
	local INSTALL_DIR="/opt/${PN}"
	unzip dex-tools/build/distributions/dex-tools-*.zip -d target || die "Unable to unpack a distribution archive"
	chmod 755 target/dex-tools-*/*.sh
	dodir "${INSTALL_DIR}"
	mv target/dex-tools-*/*.txt target/dex-tools-*/*.sh target/dex-tools-*/lib "${D}${INSTALL_DIR}" || die "Unable to install files"
	for I in "${D}${INSTALL_DIR}"/d2j-*.sh; do
		I="${I##*/}"
		dosym "${INSTALL_DIR}/${I}" "/usr/bin/${I%.sh}"
	done
}
