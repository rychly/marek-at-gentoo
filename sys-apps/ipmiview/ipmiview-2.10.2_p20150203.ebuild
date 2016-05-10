# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# http://git.meleeweb.net/gentoo/portage.git/tree/sys-apps/IPMIView/IPMIView-2.9.30.ebuild

EAPI=5

inherit eutils

PV_MAIN=${PV%%_*}
PV_PTCH=${PV##*_p}

DESCRIPTION="SuperMicro IPMI management tool"
HOMEPAGE="ftp://ftp.supermicro.com/utility/IPMIView/Linux/"
SRC_URI_PREFIX="ftp://ftp.supermicro.com/utility/IPMIView/Linux"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}/IPMIView_V${PV_MAIN}_bundleJRE_Linux_x32_${PV_PTCH}.tar.gz )
	amd64?	( ${SRC_URI_PREFIX}/IPMIView_V${PV_MAIN}_bundleJRE_Linux_x64_${PV_PTCH}.tar.gz )"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

QA_PREBUILT="opt/${PN}/*.so"

S="${WORKDIR}"

src_prepare() {
	local DIR="IPMIView_V${PV_MAIN}_bundleJRE_Linux"
	if use x86; then
		DIR+="_x32_${PV_PTCH}"
	elif use amd64; then
		DIR+="_x64_${PV_PTCH}"
	else
		die "unknown ARCH"
	fi
	## remove and set JRE
	rm -rf "${S}/${DIR}/jre" || die "unable to remove bundled JRE"
	sed -i 's|^\(VM_SEARCH_PATH\)=.*$|\1="/etc/java-config-2/current-system-vm/bin"|g' \
		"${S}/${DIR}"/{IPMIView20,JViewerX9,TrapReceiver,iKVM}
	sed -i 's|^\(lax.user.dir\)=.*$|\1=/tmp|g' \
		"${S}/${DIR}"/{IPMIView20.lax,JViewerX9.lax,TrapReceiver.lax,iKVM.lax}
	## chmod and rename
	chmod 644 "${S}/${DIR}"/*
	chmod 755 "${S}/${DIR}"/{IPMIView20,JViewerX9,TrapReceiver,iKVM}
	mv "${WORKDIR}/${DIR}" "${WORKDIR}/${PN}"
}

src_install() {
	dodir "/opt"
	mv "${WORKDIR}/${PN}" "${D}/opt/" || die "unable to install"
	# register paths
	dodir /etc/env.d
	echo -e "PATH=/opt/${PN}\nROOTPATH=/opt/${PN}" > "${D}/etc/env.d/10${PN}"
	# make desktop entries
	make_desktop_entry "/opt/${PN}/IPMIView20" "IPMIView" "" "Network"
}
