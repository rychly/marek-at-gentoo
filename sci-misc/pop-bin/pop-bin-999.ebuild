# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Publish or Perish is a software program that retrieves and analyzes academic citations."
HOMEPAGE="http://www.harzing.com/pop.htm#linux"
SRC_URI="http://www.harzing.com/download/pop-linux.tgz
	http://www.harzing.com/download/PoPZip.zip"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~x86 ~amd64"
PDEPEND=">=x11-libs/gtk+-2.10"

INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	find "${WORKDIR}"/* -depth | while read FILE; do
		DIR=`dirname "${FILE}"`
		NAME=`basename "${FILE}" | tr '[:upper:]' '[:lower:]'`
		[ "${FILE}" != "${DIR}/${NAME}" ] && mv -v "${FILE}" "${DIR}/${NAME}"
	done
	mv -v "${WORKDIR}"/pop* "${WORKDIR}/bin/"
	find "${WORKDIR}" -name "*.exe" | xargs chmod -v 755
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${WORKDIR}"/* "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
        dodir /etc/env.d
        echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
