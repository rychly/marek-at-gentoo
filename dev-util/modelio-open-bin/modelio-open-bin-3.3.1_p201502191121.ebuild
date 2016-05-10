# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}"
MYVERBAS=$(echo "${MYVERMAJ}" | cut -d . -f 1-2)

DESCRIPTION="Modelio is an open source modeling environment which can be extended through modules to add functionalities and services."
HOMEPAGE="http://www.modelio.org/"
SRC_URI_PREFIX="mirror://sourceforge/modeliouml/${MYVERMAJ}/${MYPNMAIN}-${MYVERMIN}"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}-linux.gtk.x86.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}-linux.gtk.x86_64.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
# https://www.modelio.org/documentation/installation/12-installation.html
DEPEND="net-libs/webkit-gtk:2" # for org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/Modelio ${MYVERBAS}"
INSTALLDIR="/opt/${PN}"

src_prepare() {
	# remove bundled Java
	rm -rf "${S}/jre" "${S}/lib"
	ln -s /etc/java-config-2/current-system-vm/jre "${S}/jre"
	# remove executable bit
	chmod a-x "${S}/icon.xpm"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Unable to move file for instalation!"
	## we will provide our own wrapper
	dodir /usr/bin
	cat <<END >"${D}/usr/bin/${MYPNMAIN}"
#!/bin/sh
exec ${INSTALLDIR}/modelio -data ~/modelio \$@
END
	fperms 755 "/usr/bin/${MYPNMAIN}"
	## we will utilise the existing launcher provided by the package
	## disabled due to wrapper in /usr/bin
	#dodir /etc/env.d
	#echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${MYPNMAIN}" "Modelio Open ${MYVERMAJ}" "${INSTALLDIR}/icon.xpm" "Development;IDE"
}
