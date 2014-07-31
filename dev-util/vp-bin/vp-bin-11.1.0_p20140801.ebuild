# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

VP_MIRROR="eu5"
#VP_SRCD="archives"
VP_SRCD="visual-paradigm"
VP_MAIN=${PV%%.?_*}
VP_FULL=${PV%%_*} VP_SPNO=${VP_FULL##*.}
VP_PTCH=${PV##*_p}
[ "${VP_SPNO}" -gt 0 ] && VP_SPREFIX="sp${VP_SPNO}_"

DESCRIPTION="Visual Paradigm is a software design tool for agile software projects which supports modeling standards such as UML, SysML, ERD, DFD, BPMN, ArchiMate, etc."
HOMEPAGE="http://www.visual-paradigm.com/product/vp"
SRC_URI_PREFIX="http://${VP_MIRROR}.visual-paradigm.com/${VP_SRCD}/vp${VP_MAIN}/${VP_SPREFIX}${VP_PTCH}/Visual_Paradigm_Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_NoInstall_${VP_MAIN//./_}_${VP_SPREFIX}${VP_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}_64bit_NoInstall_${VP_MAIN//./_}_${VP_SPREFIX}${VP_PTCH}.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Visual_Paradigm_${VP_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${VP_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${VP_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm" "Visual Paradigm ${VP_MAIN}" "${INSTALLDIR}/resources/vpuml.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Shape Editor ${VP_MAIN}" "${INSTALLDIR}/resources/vpuml.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Visual Paradigm ${VP_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/Visual_Paradigm_Product_Selector"
	einfo "and select installed installed product version and licence keys."
	einfo ""
}
