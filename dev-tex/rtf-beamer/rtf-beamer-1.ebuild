# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="RTFBeamer reads RTF version of ppt and writes out as Beamer file."
HOMEPAGE="http://spia.uga.edu/faculty_pages/monogan/latex.php"
SRC_URI="http://spia.uga.edu/faculty_pages/monogan/computing/latex/RTFBeamer.cpp -> ${P}.cpp"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror"

src_unpack() {
	cp -v "${DISTDIR}/${A}" "${WORKDIR}"
	sed -i 's/system("[pP][aA][uU][sS][eE]");/system("read -p \\"press enter ...\\"");/g' "${WORKDIR}/${P}.cpp"
}

src_compile() {
	g++ "${WORKDIR}/${P}.cpp" -o "${WORKDIR}/${PN}" || die 'Cannot compile the source file!'
}

src_install() {
	dobin "${PN}" || die "Unable to install an executable binary!"
}
