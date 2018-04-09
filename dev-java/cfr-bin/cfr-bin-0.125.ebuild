# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="CFR - another java decompiler"
HOMEPAGE="http://www.benf.org/other/cfr/"
SRC_URI="http://www.benf.org/other/cfr/cfr_${PV/./_}.jar"

KEYWORDS="~x86 ~amd64"
SLOT="0"
RDEPEND=">=virtual/jdk-1.7"
RESTRICT="mirror"

S="${WORKDIR}"

src_unpack() {
	cp -L "${DISTDIR}/${A}" "${S}/${PN}.jar" || die
}

src_install() {
	local dir="/opt/${PN}"
	insinto "${dir}"
	doins ${PN}.jar
	make_wrapper "${PN%-bin}" "java -jar ${dir}/${PN}.jar" ${dir}
}
