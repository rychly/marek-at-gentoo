# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=3

inherit eutils

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}"
MYVERBAS=$(echo "${MYVERMAJ}" | cut -d . -f 1-2)

DESCRIPTION="Modelio is an open source modeling environment which can be extended through modules to add functionalities and services."
HOMEPAGE="http://www.modelio.org/"
SRC_URI_PREFIX="mirror://sourceforge/${MYPNMAIN}uml/${MYVERMAJ}/${MYPNMAIN}-open-${MYVERMIN}"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}-linux.gtk.x86.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}-linux.gtk.x86_64.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND="net-libs/webkit-gtk:2" # for org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
RDEPEND=">=virtual/jre-1.5"

#S="${WORKDIR}/Modelio ${MYVERBAS}"
S="${WORKDIR}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/lib"
	# remove executable bit
	chmod a-x "${S}/icon.xpm"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Unable to move file for instalation!"
	# we will utilise the existing launcher provided by the package
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "sh -c \"exec ${INSTALLDIR}/${MYPNMAIN} -data ~/${MYPNMAIN}\"" "Modelio ${MYVERMAJ}" "${INSTALLDIR}/icon.xpm" "Development;IDE"
}
