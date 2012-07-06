# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

T1=${PN#*-*-*-} T2=${T1%-*} TARGETOS=${T2/_/-none-}
TARGETARCH=${TARGETOS%%-*}
T1=${PV//./-} VER=${T1/-/.}
MAINVER=${VER%-*}

DESCRIPTION="Sourcery CodeBench Lite Edition contains command-line tools, including the GNU C and C++ compilers, the GNU assembler and linker, C and C++ runtime libraries, and the GNU debugger."
HOMEPAGE="http://www.codesourcery.com/sgpp/lite_edition.html"
SRC_URI="http://www.codesourcery.com/public/gnu_toolchain/${TARGETOS}/${TARGETARCH}-${VER}-${TARGETOS}-i686-pc-linux-gnu.tar.bz2 -> ${P}.tar.bz2"

LICENSE=""
KEYWORDS="x86 amd64"
RESTRICT="nomirror strip binchecks"

SLOT="0"

S="${WORKDIR}/${TARGETARCH}-${MAINVER}"
INSTALLDIR="/opt/${PN}"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/${TARGETOS}" "${S}/bin" "${S}/lib" "${S}/libexec" "${D}/${INSTALLDIR}/" || die "Cannot install"
	dodoc "${S}/share/doc/${TARGETARCH}-${TARGETOS}"/*.txt "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf"/*.pdf "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf/gcc"/*.pdf
	doman "${S}/share/doc/${TARGETARCH}-${TARGETOS}/man/man1"/*.1 "${S}/share/doc/${TARGETARCH}-${TARGETOS}/man/man7"/*.7
	doinfo "${S}/share/doc/${TARGETARCH}-${TARGETOS}/info"/*.info
	# env
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
