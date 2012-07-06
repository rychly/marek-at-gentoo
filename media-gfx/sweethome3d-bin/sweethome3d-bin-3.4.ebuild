# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit java-pkg-2

OPN="${PN%-bin}"
OPNUP="SweetHome3D"

DESCRIPTION="Sweet Home 3D is a free interior design application."
HOMEPAGE="http://sweethome3d.sourceforge.net/"
SRC_URI="x86? ( mirror://sourceforge/${OPN}/${OPNUP}/${OPNUP}-${PV}/${OPNUP}-${PV}-linux-x86.tgz )
	amd64? ( mirror://sourceforge/${OPN}/${OPNUP}/${OPNUP}-${PV}/${OPNUP}-${PV}-linux-x64.tgz )"

LICENSE="GPL"
KEYWORDS="x86 amd64"
RESTRICT="nomirror"

IUSE=""
SLOT="0"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${OPNUP}-${PV}"

src_install() {
	cd "${S}"
	dodoc "${S}"/*.TXT
	java-pkg_dojar $(grep -o 'lib/[^:]*\.jar' "${S}/${OPNUP}" | grep -v "/javaws\.jar")
	java-pkg_dojar "${S}"/jre*/"lib/javaws.jar"
	java-pkg_doso "${S}/lib"/*.so
	java-pkg_dolauncher ${PN} \
		--java_args "-Xmx1024m" \
		--main "com.eteks.sweethome3d.SweetHome3D"
}