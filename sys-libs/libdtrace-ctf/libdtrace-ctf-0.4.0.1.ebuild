# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit rpm

VERMAJ="${PV%.*}"
VERMIN="${PV#*.*.*.}"
MYVERSION="${VERMAJ}-${VERMIN}"

DESCRIPTION="A port of the Solaris Compact Type Format (CTF) library to Linux"
HOMEPAGE="https://oss.oracle.com/projects/DTrace/"
SRC_URI_PREFIX="http://public-yum.oracle.com/repo/OracleLinux/OL6/UEKR3/latest/x86_64/getPackage"
SRC_URI="${SRC_URI_PREFIX}Source/${PN}-${MYVERSION}.src.rpm"

KEYWORDS="amd64"
SLOT="0"
RESTRICT="mirror"
LICENSE="GPL-2"
IUSE="debug"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${VERMAJ}"

src_install() {
	local libdir=$(get_libdir)
	dodir /usr/{include,${libdir}}
	mv "${S}/include/sys" "${D}/usr/include/" || die "Cannot install header files"
	mv "${S}"/build-*/${PN}.so* "${D}/usr/${libdir}/" || die "Cannot install dynamic libraries"
	## CTF dumping tool meant for debugging
	if use debug; then
		dodir /usr/bin
		mv "${S}"/build-*/ctf_dump "${D}/usr/bin/" || die "Cannot install executables"
	fi
}
