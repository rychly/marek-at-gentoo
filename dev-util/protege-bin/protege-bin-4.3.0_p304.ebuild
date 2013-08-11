# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

PV_DIST="4.2"
PV_MAIN=${PV%*.*}
PV_FULL=${PV/_p/-}

DESCRIPTION="An ontology editor and knowledge-base framework for ontologies in OWL, RDF(S), and XML Schema formats."
HOMEPAGE="http://protege.stanford.edu/"
SRC_URI="http://protege.stanford.edu/download/protege/${PV_MAIN}/zip/protege-${PV_FULL}.zip
	http://protege.stanford.edu/images/ProtegeLogo.gif"

LICENSE="MPL-1.1"
SLOT="4"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Protege_${PV_DIST}"
INSTALLDIR="/opt/${PN}-${SLOT}"

src_unpack() {
	unpack ${A}
	# remove non-Linux executables
	rm -rf "${S}"/*.{bat,command}
	# make Linux scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# switch to exec instead of fork
	sed -i 's/^java /exec java /g' "${S}/run.sh"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/run.sh" "${D}/${INSTALLDIR}/ProtegeLauncher${SLOT}" || die "Cannot rename the launcher script!"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install application!"
	cp "${DISTDIR}/ProtegeLogo.gif" "${D}/${INSTALLDIR}" || die "Cannot install application icon!"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}-${SLOT}"
	make_desktop_entry "${INSTALLDIR}/ProtegeLauncher${SLOT}" "Protégé Desktop ${PV_MAIN}" "${INSTALLDIR}/ProtegeLogo.gif" "Development;IDE"
}
