# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

PV_MAJ=${PV%%_*}
PV_REL=${PV##*_p}

DESCRIPTION="The free, Java based and open source Geographic Information System for the World"
HOMEPAGE="http://openjump.org/"
SRC_URI="mirror://sourceforge/jump-pilot/OpenJUMP/${PV_MAJ}/OpenJUMP-Portable-${PV_MAJ}-r${PV_REL}-PLUS.zip"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
RESTRICT="mirror"

SLOT="0"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/OpenJUMP-${PV_MAJ}-r${PV_REL}-PLUS"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	# remove Windows/MacOS files
	find "${S}" -regex '.*\.\(exe\|bat\|command\|app\)$' | xargs rm -rf --verbose
	egrep -R "^#!.*/bin/" "${S}" | cut -d ":" -f 1 | xargs chmod --verbose 755
	# move log file
	sed -i 's/\(<param name="File" value="\)\([^"]*"\/>\)/\1\/tmp\/\2/' "${S}/bin/log4j.xml"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}/bin" "${S}/lib" "${D}/${INSTALLDIR}/" || die "Cannot install core-files"
	dodoc "${S}"/*.txt #"${S}/licenses"/*.txt
	make_desktop_entry "${INSTALLDIR}/bin/oj_linux.sh" "OpenJUMP GIS" "${INSTALLDIR}/lib/icons/oj.png" "Network;Geography"
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
