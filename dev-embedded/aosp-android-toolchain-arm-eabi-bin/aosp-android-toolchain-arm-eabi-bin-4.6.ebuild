# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="Prebuild Android (AOSP) gcc toolchain."
EGIT_REPO_URI="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-${PV}"
HOMEPAGE="https://source.android.com/source/building-kernels.html https://android.googlesource.com/toolchain ${EGIT_REPO_URI}"

if [[ "${ABI}" == "x86" ]]; then
	# log: Commit arm-eabi-4.6 toolchain for building kernel.
	EGIT_COMMIT="b4ecd7806d8f46cddeacaf9f8de92c191fb266e4"
elif [[ "${ABI}" == "amd64" ]]; then
	# log: Upgrade to host 64bit arm-eabi toolchain.
	#EGIT_COMMIT="d73a051b1fd1d98f5c2463354fb67898f0090bdb" # HEAD is OK for amd64
	true
else
	die "Unsupported ABI value '${ABI}'!"
fi

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
KEYWORDS="x86 amd64"
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
