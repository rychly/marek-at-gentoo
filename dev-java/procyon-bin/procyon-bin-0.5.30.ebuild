# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Java decompiler, inspired by (and borrowed heavily from) ILSpy and Mono.Cecil"
HOMEPAGE="https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
SRC_URI="https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-${PV}.jar -> ${P}.jar"

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
