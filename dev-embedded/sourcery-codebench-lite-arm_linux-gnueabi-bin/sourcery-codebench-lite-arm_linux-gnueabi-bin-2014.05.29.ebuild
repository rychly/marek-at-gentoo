# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

RELEASE=2795
PACKAGE=12813

# There are several updates of this release (Sourcery CodeBench 2014.05).
# The latest is release 3169 (Sourcery CodeBench 2014.05-73) from 21 February 2016. See https://sourcery.mentor.com/GNUToolchain/release3169
# However, it cannot be downloaded as we don't know its package number and evaluations are no longer available.

T1=${PN#*-*-*-} T2=${T1%-*} TARGETOS=${T2/_/-none-}
TARGETARCH=${TARGETOS%%-*}
HOSTOS=i686-pc-linux-gnu
T1=${PV//./-} VER=${T1/-/.}
MAINVER=${VER%-*}

DESCRIPTION="Sourcery CodeBench environment for embedded C/C++ development on ARM"
HOMEPAGE="http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/ https://sourcery.mentor.com/GNUToolchain/release${RELEASE}"
SRC_URI="https://sourcery.mentor.com/public/gnu_toolchain/${TARGETOS}/${TARGETARCH}-${VER}-${TARGETOS}-${HOSTOS}.tar.bz2 -> ${P}.tar.bz2"
#SRC_URI="https://sourcery.mentor.com/GNUToolchain/package${PACKAGE}/public/${TARGETOS}/${TARGETARCH}-${VER}-${TARGETOS}-${HOSTOS}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="ESHLA"
KEYWORDS="x86 amd64"
RESTRICT="mirror strip binchecks"

SLOT="${RELEASE}"

S="${WORKDIR}/${TARGETARCH}-${MAINVER}"
INSTALLDIR="/opt/${PN}-r${RELEASE}"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/${TARGETOS}" "${S}/bin" "${S}/lib" "${S}/libexec" "${D}/${INSTALLDIR}/" || die "Cannot install"
	dodoc "${S}/share/doc/${TARGETARCH}-${TARGETOS}"/*.txt "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf"/*.pdf "${S}/share/doc/${TARGETARCH}-${TARGETOS}/pdf/gcc"/*.pdf
	# We use full package name (one for each ${SLOT}) share directory instead of doman and doinfo
	insinto "/usr/share/${P}/man"
	doins "${S}/share/doc/${TARGETARCH}-${TARGETOS}/man/man1"/* # not man7 as we do not install man-pages for licences
	insinto "/usr/share/${P}/info"
	doins "${S}/share/doc/${TARGETARCH}-${TARGETOS}/info"/*.info
	docompress "/usr/share/${P}/man" "/usr/share/${P}/info"
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
