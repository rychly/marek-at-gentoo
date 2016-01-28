# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Prebuild Android (AOSP) gcc toolchain."
EGIT_REPO_URI="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-${PV}"
HOMEPAGE="https://source.android.com/source/building-kernels.html https://android.googlesource.com/toolchain ${EGIT_REPO_URI}"

# HEAD is OK for amd64 (x86 is not supported)

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
KEYWORDS="amd64"
RESTRICT="mirror strip binchecks"

SLOT="${PV}"

S="${WORKDIR}"
INSTALLDIR="/opt/${P}"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}/" || die "Cannot install"
	docompress "${INSTALLDIR}/share"/{info,man}
	# env
	#dodir /etc/env.d
	#echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}

pkg_postinst() {
	einfo ""
	einfo "To use the development environment, you will need to add the following directory into PATH:"
	ewarn "    ${INSTALLDIR}/bin"
	einfo ""
}
