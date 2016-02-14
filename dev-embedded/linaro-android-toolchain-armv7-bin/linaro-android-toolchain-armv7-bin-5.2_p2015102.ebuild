# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

#ARCHIVE="-archive"
#BUILDATE="2012-09-19_22-23-02"

GCCVER=${PV%_p*}
PVPATCH=${PV#*_p}
PATCHVER=${PVPATCH:0:4}.${PVPATCH:4:2}
BUILDNO=${PVPATCH:6}
LINAROVER1="${GCCVER}-${PATCHVER}"
[[ -z "${ARCHIVE}" ]] \
&& LINAROVER2="${LINAROVER1}" \
|| LINAROVER2="linaro-${LINAROVER1}-${BUILDNO}-${BUILDATE}-linux"

DESCRIPTION="Build and verify Android with the Linaro Toolchain."
HOMEPAGE="https://wiki.linaro.org/Platform/Android/Toolchain https://android-build.linaro.org/builds/~linaro-android/toolchain-${LINAROVER1}/#build=${BUILDNO}"
SRC_URI="https://snapshots.linaro.org/android/~linaro-android${ARCHIVE}/toolchain-${LINAROVER1}/${BUILDNO}/android-toolchain-armv7-${LINAROVER2}-x86.tar.bz2"

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
KEYWORDS="x86 amd64"
RESTRICT="mirror strip binchecks"

SLOT="${LINAROVER1}"

S="${WORKDIR}/android-toolchain-eabi"
INSTALLDIR="/opt/${PN}-${LINAROVER1}"

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
