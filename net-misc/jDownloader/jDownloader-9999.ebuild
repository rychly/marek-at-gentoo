# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit java-utils-2 eutils

DESCRIPTION="A free, open-source download management tool with a huge community of developers that makes downloading as easy and fast as it should be."
HOMEPAGE="http://www.jdownloader.org/"

SLOT="0"
KEYWORDS="x86 amd64"
LICENSE="GPL-3"

DEPEND="net-misc/wget
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/JDownloader"

src_unpack() {
	wget -O "${T}/${PN}.zip" "http://94.23.204.158/JDownloader.zip" || die "Unable to fetch!"
	unzip "${T}/${PN}.zip" -d "${WORKDIR}"
}

src_prepare() {
	# remove Windows files
	rm -rf \
		"${S}/plugins/jdshutdown/windows" \
		"${S}/tools"/{Windows,linux,mac} \
		"${S}/tools"/flashgot.*
	find "${S}" -regex '.*\.\(exe\|cmd\|bat\|dll\)$' -print0 | xargs -0 rm --verbose
	# relink tmp
	rm -rf "${S}/tmp" && ln -s "/tmp" "${S}/tmp"
}

src_install() {
	local INSTALLDIR="/opt/${PN}"
	# icons
	for X in 64 128 256; do
		insinto /usr/share/icons/hicolor/${X}x${X}/apps
		newins "${S}/jd/img/logo/jd_logo_${X}_${X}.png" "${PN}.png" || die "Cannot install icon files"
	done
	# install
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}${INSTALLDIR}"
	# world-writable directories
	fperms a+w "${INSTALLDIR}"
	for X in .junique config; do
		dodir "${INSTALLDIR}/${X}"
		fperms a+w "${INSTALLDIR}/${X}"
	done
	# launcher
	java-pkg_regjar "${D}${INSTALLDIR}/JDownloader.jar"
	java-pkg_dolauncher ${PN} --jar "JDownloader.jar" --pwd "${INSTALLDIR}"
	make_desktop_entry "${PN}" "JDownloader" "${PN}" "Network"
}

pkg_postinst() {
	einfo ""
	ewarn "This application is not safe in a multi-user environment, there are shared directories in the installation directory!"
	einfo ""
}
