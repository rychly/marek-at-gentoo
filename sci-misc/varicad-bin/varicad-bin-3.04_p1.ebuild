# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

PNAME="VariCAD_2008"
PLANG="en"
PVMAJ=${PV%%_p*}
PVMIN=${PV##*_p}

DESCRIPTION="A comprehensive, powerful, and easy to use 3D/2D CAD system for all aspects of mechanical engineering design."
HOMEPAGE="http://www.varicad.cz/en/home/products/description/"
SRC_URI="x86? ( http://www.varicad.cz/userdata/files/release/${PLANG}/${PNAME}-${PLANG}-${PVMAJ}-${PVMIN}.i586.rpm )
	amd64? ( http://www.varicad.cz/userdata/files/release/${PLANG}/${PNAME}-${PLANG}-${PVMAJ}-${PVMIN}.x86_64.rpm )"

LICENSE=""
KEYWORDS="x86 amd64"
RESTRICT="nomirror"

IUSE=""
SLOT="0"

S="${WORKDIR}/opt/VariCAD"
# fixed path (/opt/VariCAD/{bin,lib})
INSTALLDIR="/opt/VariCAD"

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}/" || die "Cannot install files"
	dodoc "../../usr/share/doc/packages/${PNAME}-${PLANG}/README-${PLANG}.txt"
	dodoc "../../usr/share/doc/packages/${PNAME}-${PLANG}/ReleaseNotes.txt"
	# env
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	# licence
	einfo
	einfo "Copy a licence file varicad.lck into ${INSTALLDIR}/lib/"
	einfo
}