# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

VPUML_MIRROR="eu3"
VPUML_SRCD="archives"
#VPUML_SRCD="visual-paradigm"
VPUML_MAIN=${PV%%.?_*}
VPUML_FULL=${PV%%_*} VPUML_SPNO=${VPUML_FULL##*.}
VPUML_PTCH=${PV##*_p}
[ "${VPUML_SPNO}" -gt 0 ] && VPUML_SPREFIX="sp${VPUML_SPNO}_"

DESCRIPTION="Visual Paradigm for UML (VP-UML) is a UML design tool and UML CASE tool designed to aid software development."
HOMEPAGE="http://www.visual-paradigm.com/product/vpuml/"
SRC_URI_PREFIX="http://${VPUML_MIRROR}.visual-paradigm.com/${VPUML_SRCD}/vpuml${VPUML_MAIN}/${VPUML_SPREFIX}${VPUML_PTCH}/Visual_Paradigm_for_UML_Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_NoInstall_${VPUML_MAIN//./_}_${VPUML_SPREFIX}${VPUML_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}_64bit_NoInstall_${VPUML_MAIN//./_}_${VPUML_SPREFIX}${VPUML_PTCH}.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Visual_Paradigm_for_UML_${VPUML_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${VPUML_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${VPUML_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_for_UML_${VPUML_MAIN}" "Visual Paradigm for UML ${VPUML_MAIN}" "${INSTALLDIR}/resources/vpuml.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Shape Editor for VPUML ${VPUML_MAIN}" "${INSTALLDIR}/resources/vpuml.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Visual Paradigm for UML ${VPUML_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/VP-UML_Product_Edition_Manager"
	einfo "and select installed installed product version and licence keys."
	einfo ""
}
