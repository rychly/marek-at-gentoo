# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils

VP_MIRROR="eu5"
#VP_SRCD="archives"
VP_SRCD="visual-paradigm"
VP_MAIN=${PV%%.?_*}
VP_FULL=${PV%%_*} VP_SPNO=${VP_FULL##*.}
VP_PTCH=${PV##*_p}
[ "${VP_SPNO}" -gt 0 ] && VP_SPREFIX="sp${VP_SPNO}_"

DESCRIPTION="A software design tool supporting UML, SysML, ERD, DFD, BPMN, ArchiMate, etc."
HOMEPAGE="https://www.visual-paradigm.com/editions/community.jsp"
SRC_URI_PREFIX="http://${VP_MIRROR}.visual-paradigm.com/${VP_SRCD}/vpce${VP_MAIN}/${VP_SPREFIX}${VP_PTCH}"
SRC_URI_PGKPREFIX="Visual_Paradigm_CE_${VP_MAIN//./_}_${VP_SPREFIX}${VP_PTCH}"
SRC_URI_HLPFILE="Visual_Paradigm_CE_${VP_MAIN//./_}_${VP_SPREFIX}${VP_PTCH}_Help.jar"
SRC_URI="\
	amd64?	( ${SRC_URI_PREFIX}/${SRC_URI_PGKPREFIX}_Linux64_InstallFree.tar.gz )
	help?	( ${SRC_URI_PREFIX//vpce/vp}/Update/lib/vp-help.jar -> ${SRC_URI_HLPFILE} )"
LICENSE="visual-paradigm-evaluation"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="amd64"
IUSE="+help"
DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/Visual_Paradigm_CE_${VP_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A/${SRC_URI_HLPFILE}/}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/Application/uninstaller" "${S}/Application/updatesynchronizer" "${S}/Application/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${VP_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${VP_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	# install distribution package
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	# install help
	if use help; then
		insinto "${INSTALLDIR}/Application/lib"
		newins "${DISTDIR}/${SRC_URI_HLPFILE}" "vp-help.jar"
	fi
	# register paths
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/Application/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	# make desktop entries
	make_desktop_entry "${INSTALLDIR}/Application/bin/Visual_Paradigm" "Visual Paradigm Community Edition ${VP_MAIN}" "${INSTALLDIR}/Application/resources/vpuml.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/Application/bin/Visual_Paradigm_Shape_Editor" "Visual Paradigm Community Edition Shape Editor ${VP_MAIN}" "${INSTALLDIR}/Application/resources/vpuml.png" "Development;IDE"
}
