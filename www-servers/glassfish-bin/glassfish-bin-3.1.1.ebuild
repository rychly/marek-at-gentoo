# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils systemd user java-pkg-2

DESCRIPTION="SUN Java EE 5 application server"
HOMEPAGE="http://glassfish.dev.java.net/"
SRC_URI="ml? ( http://download.java.net/glassfish/${PV}/release/glassfish-${PV}-ml.zip )
	!ml? ( http://download.java.net/glassfish/${PV}/release/glassfish-${PV}.zip )"

SLOT="${PV%%.*}"
KEYWORDS="~x86 ~amd64"
LICENSE="|| ( CDDL GPL-2 )"
RESTRICT="mirror"
IUSE="+ml"

S="${WORKDIR}/glassfish${SLOT}"
NAME="glassfish${SLOT}-bin"
DEST="/opt/${NAME}"

RDEPEND="virtual/jdk"

DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	# remove Windows and MacOS files
	find "${S}" -regex '.*\.\(exe\|cmd\|bat\|dll\|dylib\)$' | xargs rm --verbose
	# prepare conf.d and init.d files
	sed -e "s:%%%DEST%%%:${DEST}:g" "${FILESDIR}/${PN}.conf" > "${WORKDIR}/${PN}.conf"
	sed -e "s:%%%DEST%%%:${DEST}:g" "${FILESDIR}/${PN}.init" > "${WORKDIR}/${PN}.init"
	sed -e "s:%%%DEST%%%:${DEST}:g" -e "s:%%%NAME%%%:${NAME}:g" "${FILESDIR}/${PN}.service" > "${WORKDIR}/${NAME}.service"
	sed -e "s:%%%DEST%%%:${DEST}:g" -e "s:%%%NAME%%%:${NAME}:g" "${FILESDIR}/${PN}.service-temp" > "${WORKDIR}/${NAME}@.service"
}

src_install() {
	# app-dir
	dodir "${DEST}"
	mv "${S}"/* "${D}${DEST}"
	# init/conf-scripts
	newconfd "${WORKDIR}/${PN}.conf" "${NAME}"
	newinitd "${WORKDIR}/${PN}.init" "${NAME}"
	systemd_dounit "${WORKDIR}/${NAME}.service"
	systemd_dounit "${WORKDIR}/${NAME}@.service"
	# default domain
	dodir "/etc/${NAME}"
	local domdir="${DEST}/glassfish/domains"
	mv "${D}${domdir}"/* "${D}/etc/${NAME}/"
	rmdir "${D}${domdir}"
	dosym "/etc/${NAME}" "${domdir}"
}

pkg_preinst() {
	enewgroup glassfish
	enewuser glassfish -1 -1 /dev/null glassfish
	chown -R glassfish:glassfish "${D}/${DEST}"
}
