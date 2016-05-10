# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit java-utils-2 eutils

TEMP="${PV//./_}" MY_PV="${TEMP//rc/ea}"

DESCRIPTION="SmartGit/Hg is a client for Git and Mercurial."
HOMEPAGE="http://www.syntevo.com/smartgithg/"
SRC_URI="http://www.syntevo.com/download/smartgithg/${PN}-generic-${MY_PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/smartgithg-${MY_PV}"
INSTALLDIR="/opt/${PN}"

src_prepare() {
	sed -i \
		-e "s:^\\(SMARTGIT_HOME=\\).*\$:\\1${INSTALLDIR}:g" \
		-e 's:\($SMARTGIT_HOME\)/lib/:\1/:g' \
		"${S}/bin/smartgithg.sh"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/lib"/* "${S}/bin/smartgithg.sh" "${D}${INSTALLDIR}" || die "Cannot install needed files"

	java-pkg_regjar "${D}${INSTALLDIR}"/*.jar

	java-pkg_dolauncher ${PN} \
		--java_args "-Dsun.io.useCanonCaches=false -Xmx256m -Xverify:none -Dsmartgit.vm-xmx=256m" \
		--jar bootloader.jar

	for X in 32 48 64 128 256; do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}/bin/smartgithg-${X}.png" "${PN}.png" || die "Cannot install needed files"
	done

	make_desktop_entry "${PN}" "SmartGit/Hg" "${PN}" "Development;RevisionControl" \
		"Keywords=git;hg;svn;mercurial;subversion;\nGenericName=Git&Hg-Client + SVN-support\nMimeType=x-scheme-handler/smartgit;"

	dodoc "${S}"/*.txt
}
