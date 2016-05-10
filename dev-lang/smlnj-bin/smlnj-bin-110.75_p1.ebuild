# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

SABAYON_URI="mirror://sabayon/../entropy/standard/sabayonlinux.org/packages"
ENTROPY_PACKAGE="${CATEGORY}:${PN%-bin}-${PV%_p*}~${PV#*_p}"

DESCRIPTION="Standard ML of New Jersey compiler and libraries (Sabayon/Entropy binary)."
HOMEPAGE="http://www.smlnj.org"
SRC_URI="x86? ( ${SABAYON_URI}/x86/5/${ENTROPY_PACKAGE}.tbz2 -> ${P}-x86.tar.bz2 )
	amd64? ( ${SABAYON_URI}/amd64/5/${ENTROPY_PACKAGE}.tbz2 -> ${P}-amd64.tar.bz2 )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="!dev-lang/smlnj"

src_install() {
	mv "${WORKDIR}/usr" "${D}"
}
