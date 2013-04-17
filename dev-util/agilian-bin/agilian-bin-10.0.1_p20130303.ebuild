# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

AG_MIRROR="eu3"
AG_SRCD="archives"
#AG_SRCD="visual-paradigm"
AG_MAIN=${PV%%.?_*}
AG_FULL=${PV%%_*} AG_SPNO=${AG_FULL##*.}
AG_PTCH=${PV##*_p}
[ "${AG_SPNO}" -gt 0 ] && AG_SPREFIX="sp${AG_SPNO}_"

DESCRIPTION="Agilian is an agile modeling tool that supports UML, BPMN, ERD, screen mock up and Mind Mapping."
HOMEPAGE="http://www.visual-paradigm.com/product/ag/"
SRC_URI_PREFIX="http://${AG_MIRROR}.visual-paradigm.com/${AG_SRCD}/ag${AG_MAIN}/${AG_SPREFIX}${AG_PTCH}/Agilian_Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_NoInstall_${AG_MAIN//./_}_${AG_SPREFIX}${AG_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}_64bit_NoInstall_${AG_MAIN//./_}_${AG_SPREFIX}${AG_PTCH}.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Agilian_${AG_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${AG_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${AG_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/bin/Agilian_${AG_MAIN}" "Agilian ${AG_MAIN}" "${INSTALLDIR}/resources/ag.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Shape Editor for Agilian ${AG_MAIN}" "${INSTALLDIR}/resources/ag.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Agilian ${AG_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/AG_Product_Edition_Manager"
	einfo "and select installed installed product version and licence keys."
	einfo ""
}
