# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="The Mobility Workbench (MWB) is a tool for manipulating and analyzing mobile concurrent systems described in the pi-calculus."
HOMEPAGE="https://www.it.uu.se/research/group/mobility/mwb"
SRC_URI="https://www.it.uu.se/profundis/mwb-dist/${PN}99-sources-${PV}.tar.gz
	doc? ( https://www.it.uu.se/profundis/mwb-dist/x4.ps.gz )"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86" # the same as for dev-lang/smlnj or dev-lang/smlnj-bin
RESTRICT="mirror"
IUSE="doc"

RDEPEND="|| ( >=dev-lang/smlnj-110.55 >=dev-lang/smlnj-bin-110.55 )"

DEPEND="${RDEPEND}"

src_compile() {
	sed -i -e '2 i cd $(dirname ${0})' -e '2 i exec \\' "${WORKDIR}/mwb.sh"
	sml -m sources.cm saveit.sml || die "Unable to compile!"
}

src_install() {
	local INSTALLDIR=/opt/${PN}
	# clean
	rm "${WORKDIR}"/{.,mc}/*.{sig,str,grm,grm.desc,sml,lex,cm} 2>/dev/null
	# install
	dodir "${INSTALLDIR}"
	mv "${WORKDIR}"/* "${WORKDIR}"/.cm "${D}/${INSTALLDIR}"
	# PATH
	dodir "/etc/env.d"
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" >"${D}/etc/env.d/50${PN}"
}
