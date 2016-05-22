# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

RELEASE="europa.winter" # EPP Europa Build Status 20080228-0640
MIRROR="http://ftp.sh.cvut.cz/MIRRORS/eclipse"

DESCRIPTION="The Eclipse IDE for Java EE Developers to build Java and Java EE applications"
# Contains binaries of RCP/Platform, CVS, EMF, GEF, JDT, Mylyn, WST, PDE, Datatools, JST.
HOMEPAGE="http://www.eclipse.org/downloads/moreinfo/jee.php"
SRC_URI="x86? ( ${MIRROR}/technology/epp/downloads/release/${RELEASE%%.*}/${RELEASE##*.}/eclipse-jee-${RELEASE//./-}-linux-gtk.tar.gz )
	amd64? ( ${MIRROR}/technology/epp/downloads/release/${RELEASE%%.*}/${RELEASE##*.}/eclipse-jee-${RELEASE//./-}-linux-gtk-x86_64.tar.gz )"
LICENSE="EPL-1.0"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/eclipse"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	rm -rf "${S}/about_files"
	mv "${S}"/*.html "${S}/readme"
	mv "${S}/readme" "${S}/.readme"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
	dodoc "${S}/.readme"/*
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}"/etc/env.d/10eclipse
}
