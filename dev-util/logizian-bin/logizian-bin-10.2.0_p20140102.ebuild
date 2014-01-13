# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

LZ_MIRROR="eu5"
LZ_SRCD="archives"
#LZ_SRCD="visual-paradigm"
LZ_MAIN=${PV%%.?_*}
LZ_FULL=${PV%%_*} LZ_SPNO=${LZ_FULL##*.}
LZ_PTCH=${PV##*_p}
[ "${LZ_SPNO}" -gt 0 ] && LZ_SPREFIX="sp${LZ_SPNO}_"

DESCRIPTION="Logizian is a process modeling software designed to graphically represent business processes and workflows in BPMN 2.0."
HOMEPAGE="http://www.visual-paradigm.com/product/lz/"
SRC_URI_PREFIX="http://${LZ_MIRROR}.visual-paradigm.com/${LZ_SRCD}/lz${LZ_MAIN}/${LZ_SPREFIX}${LZ_PTCH}/Logizian_Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}_NoInstall_${LZ_MAIN//./_}_${LZ_SPREFIX}${LZ_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}_64bit_NoInstall_${LZ_MAIN//./_}_${LZ_SPREFIX}${LZ_PTCH}.tar.gz )"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/Logizian_${LZ_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${LZ_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${LZ_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/bin/Logizian" "Logizian ${LZ_MAIN}" "${INSTALLDIR}/resources/lz.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Shape Editor for Logizian ${LZ_MAIN}" "${INSTALLDIR}/resources/lz.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Logizian ${LZ_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/Logizian_Product_Selector"
	einfo "and select installed installed product version and licence keys."
	einfo ""
}
