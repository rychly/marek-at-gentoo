# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

MIRROR="http://archive.eclipse.org/eclipse/downloads/drops"
[[ "${PV%%.*}" -gt 3 ]] && MIRROR+="${PV%%.*}"

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://archive.eclipse.org/eclipse/downloads/"
SRC_URI="x86? ( ${MIRROR}/R-${PV/_p/-}/eclipse-SDK-${PV%_p*}-linux-gtk.tar.gz )
	amd64? ( ${MIRROR}/R-${PV/_p/-}/eclipse-SDK-${PV%_p*}-linux-gtk-x86_64.tar.gz )"
LICENSE="EPL-1.0"
SLOT="${PV%.*}"
RESTRICT="mirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND="virtual/jre"

S="${WORKDIR}/eclipse"
INSTALLDIR="/opt/${PN}-v${SLOT}"

src_prepare() {
	rm -rf "${S}/about_files"
	mv "${S}"/*.html "${S}/readme"
	mv "${S}/readme" "${S}/.readme"
	cp "${S}/plugins"/org.eclipse.sdk_*/eclipse48.png "${S}"
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${T}/50${PN}-${SLOT}"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
	dodoc "${S}/.readme"/*
	make_desktop_entry "${INSTALLDIR}/eclipse" "Eclipse Tools Platform ${SLOT}" "${INSTALLDIR}/eclipse48.png" "Development;IDE"
	doenvd "${T}/50${PN}-${SLOT}"
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${INSTALLDIR}\"" > "${D}/etc/revdep-rebuild/50${PN}-${SLOT}"
}

pkg_postinst() {
	# info about additional packages
	einfo
	einfo "To add plugin repositories for all Eclipse version, go to menu Help > Install New Software and add:"
	einfo "* Eclipse 3.4 Ganymede:	http://download.eclipse.org/releases/ganymede"
	einfo "* Eclipse 3.5 Galileo:	http://download.eclipse.org/releases/galileo"
	einfo "* Eclipse 3.6 Helios:	http://download.eclipse.org/releases/helios"
	einfo "* Eclipse 3.7 Indigo:	http://download.eclipse.org/releases/indigo"
	einfo "* Eclipse 4.2 Juno:	http://download.eclipse.org/releases/juno"
	einfo "* Eclipse 4.3 Kepler:	http://download.eclipse.org/releases/kepler"
	einfo "* Eclipse 4.4 Luna:	http://download.eclipse.org/releases/luna"
	einfo "* Eclipse 4.5 Mars:	http://download.eclipse.org/releases/mars"
	einfo "* Eclipse 4.6 Neon:	http://download.eclipse.org/releases/neon"
	einfo
	einfo "To enable EMF/GMF, search for, select, and install:"
	einfo "* Ecore Tools"
	einfo "* Ecore Tools SDK"
	einfo "* EMF - Eclipse Modeling Framework Runtime and Tools"
	einfo "* EMF SDK - Eclipse Modeling Framework SDK"
	einfo "* Graphical Modeling Framework Runtime"
	einfo "* Graphical Modeling Framework SDK"
	einfo
	einfo "To enable Xtext and SADL, add repositories:"
	einfo "* Xtext: http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases"
	einfo "* SADL: http://sadl.sourceforge.net/update"
	einfo "and search for, select, and install:"
	einfo "* Semantic Application Design Language Version 2"
	einfo
}
