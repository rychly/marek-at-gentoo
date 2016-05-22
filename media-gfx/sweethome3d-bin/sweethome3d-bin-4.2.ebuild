# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit java-pkg-2 eutils

OPN="${PN%-bin}"
OPNUP="SweetHome3D"

DESCRIPTION="Sweet Home 3D is a free interior design application"
HOMEPAGE="http://www.sweethome3d.com/"
SRC_URI="x86? ( mirror://sourceforge/${OPN}/${OPNUP}/${OPNUP}-${PV}/${OPNUP}-${PV}-linux-x86.tgz )
	amd64? ( mirror://sourceforge/${OPN}/${OPNUP}/${OPNUP}-${PV}/${OPNUP}-${PV}-linux-x64.tgz )"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
RESTRICT="mirror"

IUSE=""
SLOT="0"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${OPNUP}-${PV}"

src_unpack() {
	unpack ${A}
	unzip "${S}/lib/SweetHome3D.jar" "com/eteks/sweethome3d/resources/frameIcon32x32.png" || die "Cannot unpack icon!"
}

src_install() {
	dodoc "${S}"/*.TXT
	java-pkg_dojar $(grep -o 'lib/[^:]*\.jar' "${S}/${OPNUP}" | grep -v "/javaws\.jar")
	java-pkg_dojar "${S}"/jre*/"lib/javaws.jar"
	java-pkg_doso "${S}/lib"/*.so
	java-pkg_dolauncher ${PN} \
		--java_args "-Xmx1024m" \
		--main "com.eteks.sweethome3d.SweetHome3D"
	newicon -s 32 "${WORKDIR}/com/eteks/sweethome3d/resources/frameIcon32x32.png" "${PN}.png"
	make_desktop_entry "/usr/bin/${PN}" "Sweet Home 3D" "/usr/share/icons/hicolor/32x32/apps/${PN}.png" "Graphics;Engineering"
}
