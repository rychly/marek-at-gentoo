# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

RELEASE=2322
PACKAGE=10926
T1=${PN#*-*-*-} T2=${T1%-*} TARGETOS=${T2/_/-none-}
TARGETARCH=${TARGETOS%%-*}
HOSTOS=i686-pc-linux-gnu
T1=${PV//./-} VER=${T1/-/.}
MAINVER=${VER%-*}

DESCRIPTION="Sourcery CodeBench is a complete development environment for embedded C/C++ development on ARM, Power, ColdFire, and other architectures."
HOMEPAGE="http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/ https://sourcery.mentor.com/GNUToolchain/release${RELEASE}"
SRC_URI="https://sourcery.mentor.com/public/gnu_toolchain/${TARGETOS}/${TARGETARCH}-${VER}-${TARGETOS}-${HOSTOS}.tar.bz2 -> ${P}.tar.bz2"
#SRC_URI="https://sourcery.mentor.com/GNUToolchain/package${PACKAGE}/public/${TARGETOS}/${TARGETARCH}-${VER}-${TARGETOS}-${HOSTOS}.tar.bz2 -> ${P}.tar.bz2"

LICENSE=""
KEYWORDS="x86 amd64"
RESTRICT="nomirror strip binchecks"

SLOT="0"

S="${WORKDIR}/${TARGETARCH}-${MAINVER}"
INSTALLDIR="/opt/${PN}"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/${TARGETOS}" "${S}/bin" "${S}/lib" "${S}/libexec" "${S}/${HOSTOS}" "${D}/${INSTALLDIR}/" || die "Cannot install"
	dodoc "${S}/share/doc/${TARGETARCH}-${TARGETOS}"/*.txt "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf"/*.pdf "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf/gcc"/*.pdf
	doman "${S}/share/doc/${TARGETARCH}-${TARGETOS}/man/man1"/*.1 "${S}/share/doc/${TARGETARCH}-${TARGETOS}/man/man7"/*.7
	doinfo "${S}/share/doc/${TARGETARCH}-${TARGETOS}/info"/*.info
	# env
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
