# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

GCCVER=${PV%_p*}
PVPATCH=${PV#*_p}
PATCHVER=${PVPATCH:0:4}.${PVPATCH:4:2}
BUILDNO=${PVPATCH:6}
[[ -n "${BUILDNO}" ]] && LINAROVER="${GCCVER}-${PATCHVER}-${BUILDNO}" || LINAROVER="${GCCVER}-${PATCHVER}"

DESCRIPTION="Linaro Stable Binary Toolchain provides cross-toolchain executables (compiler, debugger, linker, etc.) and shared libraries (libstdc++, libc, etc.) that target ARM GNU/Linux environments."
HOMEPAGE="https://wiki.linaro.org/WorkingGroups/ToolChain http://releases.linaro.org/components/toolchain/binaries/${LINAROVER}/"
SRC_URI="\
	x86? ( http://releases.linaro.org/components/toolchain/binaries/${LINAROVER}/arm-eabi/gcc-linaro-${LINAROVER}-i686-mingw32_arm-eabi.tar.xz )
	amd64? ( http://releases.linaro.org/components/toolchain/binaries/${LINAROVER}/arm-eabi/gcc-linaro-${LINAROVER}-x86_64_arm-eabi.tar.xz )"

LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"
KEYWORDS="x86 amd64"
RESTRICT="mirror strip binchecks"

SLOT="${LINAROVER}"

if use x86; then
	S="${WORKDIR}/gcc-linaro-${LINAROVER}-i686-mingw32_arm-eabi"
elif use amd64; then
	S="${WORKDIR}/gcc-linaro-${LINAROVER}-x86_64_arm-eabi"
fi

INSTALLDIR="/opt/${PN}-${LINAROVER}"

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
