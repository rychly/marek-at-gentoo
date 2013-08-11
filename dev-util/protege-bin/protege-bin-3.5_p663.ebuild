# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

PV_MAIN=${PV%_p*}

DESCRIPTION="An ontology editor and knowledge-base framework for ontologies in OWL, RDF(S), and XML Schema formats."
HOMEPAGE="http://protege.stanford.edu/"
SRC_URI_BASE="http://protege.stanford.edu/download/protege/${PV_MAIN}/installanywhere/Web_Installers/InstData"
SRC_URI="x86? ( ${SRC_URI_BASE}/Linux/NoVM/install_protege_${PV_MAIN}.bin -> install_protege_${PV}-x86.bin )
	amd64? ( ${SRC_URI_BASE}/Linux_64bit/NoVM/install_protege_${PV_MAIN}.bin -> install_protege_${PV}-amd64.bin )
	http://protege.stanford.edu/images/ProtegeLogo.gif"

LICENSE="MPL-1.1"
SLOT="3"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Protege_${PV_MAIN}"
INSTALLDIR="/opt/${PN}-${SLOT}"

src_unpack() {
	# unpack
	if [ -n $(has sandbox "${FEATURES}") ]; then
		addpredict /var/.com.zerog.registry.xml
		addpredict /usr/share
	fi
	export IATEMPDIR="${T}" HOME="${T}"
	sh "${DISTDIR}/${A% *}" \
		LAX_VM /etc/java-config-2/current-system-vm/bin/java \
		-i Silent "-DUSER_INSTALL_DIR=${S}" || die "unpack failed"
	# remove un-installer
	rm -rf "${S}/Uninstall_Protege ${PV_MAIN}"
	# fix LaunchAnywhere install directory
	#sed -i "s:${S}:${INSTALLDIR}:g" "${S}/Protege.lax"
	# remove LaunchAnywhere scripts
	rm "${S}/Protege" "${S}/Protege.lax"
	# fix persmissions
	find "${S}" -type d -exec chmod 755 {} \;
	find "${S}" -type f -exec chmod 644 {} \;
	# make Linux scripts executable and configuration file writable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	chmod 666 "${S}/protege.properties"
	# switch to exec instead of fork
	for I in run_protege.sh run_protege_server.sh shutdown_protege_server.sh; do
		sed -i 's/^\([^ ]*java\) /exec \1 /g' "${S}/${I}"
	done
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/run_protege.sh" "${D}/${INSTALLDIR}/ProtegeLauncher${SLOT}" || die "Cannot rename the launcher script!"
	mv "${S}/run_protege_server.sh" "${D}/${INSTALLDIR}/run_protege_${SLOT}_server.sh"
	mv "${S}/shutdown_protege_server.sh" "${D}/${INSTALLDIR}/shutdown_protege_${SLOT}_server.sh"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install application!"
	cp "${DISTDIR}/ProtegeLogo.gif" "${D}/${INSTALLDIR}" || die "Cannot install application icon!"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}-${SLOT}"
	make_desktop_entry "${INSTALLDIR}/ProtegeLauncher${SLOT}" "Protégé Desktop ${PV_MAIN}" "${INSTALLDIR}/ProtegeLogo.gif" "Development;IDE"
}
