# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

VPS_SRCD="archives"
#VPS_SRCD="visual-paradigm"
VPS_MAIN=${PV%%.?_*}
VPS_FULL=${PV%%_*} VPS_SPNO=${VPS_FULL##*.}
VPS_PTCH=${PV##*_p}

DESCRIPTION="A collection of several Visual Paradigm tools and editors"
HOMEPAGE="http://www.visual-paradigm.com/product/vpsuite/"
SRC_URI="http://eu3.visual-paradigm.com/${VPS_SRCD}/vpsuite${VPS_MAIN}/sp${VPS_SPNO}_${VPS_PTCH}/VP_Suite_Linux_NoInstall_${VPS_MAIN//./_}_sp${VPS_SPNO}_${VPS_PTCH}.tar.gz"
LICENSE="visual-paradigm-evaluation"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/VP_Suite${VPS_MAIN}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${S}/jre" "${S}/uninstaller" "${S}/updatesynchronizer" "${S}/bin/vp_windows"
	# make scripts executable
	egrep --null --files-with-matches -R "^#!.*/bin/" "${S}" | xargs --null chmod --verbose 755
	# copy basic configuration files if any
	if [ -f "${FILESDIR}/${VPS_MAIN}.tgz" ]; then
		tar xzf "${FILESDIR}/${VPS_MAIN}.tgz" -C "${S}" || die "Cannot copy basic configuration files!"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${S}/.install4j" "${D}/${INSTALLDIR}"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/launcher/run_ag" "Agilian (VPSuite ${VPS_MAIN})" "${INSTALLDIR}/resources/ag.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/launcher/run_bpva" "Business Process Visual Architect (VPSuite ${VPS_MAIN})" "${INSTALLDIR}/resources/bpva.png" "Development;IDE"
	make_desktop_entry "${INSTALLDIR}/launcher/run_vpuml" "Visual Paradigm for UML (VPSuite ${VPS_MAIN})" "${INSTALLDIR}/resources/vpuml.png" "Development;IDE"
}

pkg_postinst() {
	einfo ""
	einfo "To finish the Visual Paradigm Suite ${VPS_MAIN} installation you need to execute:"
	ewarn "    ${INSTALLDIR}/bin/VP_Suite"
	einfo "and select installed Visual Paradigm products, their versions and licence keys."
	einfo ""
}
