# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_PV=${PV//_/-}

DESCRIPTION="A 2D CAD package based upon Qt"
HOMEPAGE="http://www.ribbonsoft.com/en/"
SRC_URI="http://www.ribbonsoft.com/archives/qcad/qcad-${MY_PV}-trial-linux-x86.tar.gz"

LICENSE="GPL-3"
SLOT="0"
RESTRICT="mirror"
KEYWORDS="amd64 hppa ppc ppc64 x86"

S="${WORKDIR}/qcad-${MY_PV}-trial-linux-x86"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	find "${S}" -name '*.so.*' -exec chmod a-x {} +
}

src_install () {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install core-files"
	make_desktop_entry "${INSTALLDIR}/qcad-trial" "QCAD 3 Professional" "${INSTALLDIR}/scripts/qcad_icon.svg" "Development;IDE"
	# environment variables
	dodir "/etc/env.d"
	cat > "${D}/etc/env.d/50${PN}" <<END
PATH=${INSTALLDIR}/bin
ROOTPATH=${INSTALLDIR}
END
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${INSTALLDIR}\"" > "${D}/etc/revdep-rebuild/50${PN}"
}
