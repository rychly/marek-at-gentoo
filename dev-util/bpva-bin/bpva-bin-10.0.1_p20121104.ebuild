# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

BPVA_MIRROR="eu3"
#BPVA_SRCD="archives"
BPVA_SRCD="visual-paradigm"
BPVA_MAIN=${PV%%.?_*}
BPVA_FULL=${PV%%_*} BPVA_SPNO=${BPVA_FULL##*.}
BPVA_PTCH=${PV##*_p}
[ "${BPVA_SPNO}" -gt 0 ] && BPVA_SPREFIX="sp${BPVA_SPNO}_"

DESCRIPTION="Business Process Visual ARCHITECT is a fast and cross-platforms BPM tool that supports Business Process Management (BPM), Business Process Modeling Notation (BPMN) 2.0, data flow diagram (DFD), and organization chart."
HOMEPAGE="http://www.visual-paradigm.com/product/bpva/"
SRC_URI_PREFIX="http://${BPVA_MIRROR}.visual-paradigm.com/${BPVA_SRCD}/bpva${BPVA_MAIN}/${BPVA_SPREFIX}${BPVA_PTCH}/Business_Process_Visual_ARCHITECT_Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_NoInstall_${BPVA_MAIN//./_}_${BPVA_SPREFIX}${BPVA_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}_64bit_NoInstall_${BPVA_MAIN//./_}_${BPVA_SPREFIX}${BPVA_PTCH}.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Business_Process_Visual_ARCHITECT_${BPVA_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${BPVA_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${BPVA_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/bin/Business_Process_Visual_ARCHITECT_${BPVA_MAIN}" "Business Process Visual Architect ${BPVA_MAIN}" "${INSTALLDIR}/resources/bpva.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Shape Editor for BPVA ${BPVA_MAIN}" "${INSTALLDIR}/resources/bpva.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Business Process Visual Architect ${BPVA_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/BPVA_Product_Edition_Manager"
	einfo "and select installed installed product version and licence keys."
	einfo ""
}
