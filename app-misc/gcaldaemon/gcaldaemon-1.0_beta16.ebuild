# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="GCALDaemon offers two-way synchronization between Google Calendar and various iCalendar compatible calendar applications."
HOMEPAGE="http://gcaldaemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/gcaldaemon/${PN}-linux-${PV//_/-}.zip"

LICENSE="LGPL-2"
KEYWORDS="x86 amd64"
RESTRICT="nomirror"

IUSE="doc source"
SLOT="0"
RDEPEND="virtual/jre"

S="${WORKDIR}/GCALDaemon"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}
	use doc || rm -rf "${S}/docs" "${S}/license"
	use source || rm -rf "${S}/dev"
	rm "${S}/bin"/reload-calendar.*
}

src_compile() {
	local escID=${INSTALLDIR//\//\\\/}
	for I in "${S}/bin"/*.sh; do
		echo -n "patching and renaming $(basename $I) ... "
		sed -e "s/^\\(GCALDIR=.*\\)\$/#\\1\\nGCALDIR=${escID}/" -e "s/^java /exec java /" \
		"$I" > "$(dirname $I)/${PN}-$(basename $I .sh)" && rm "$I" \
		&& echo "done" || die "Cannot modify path in th file"
	done
	sed "s/(INSTALLDIR)/${escID}/g" "${FILESDIR}/${PN}.initd" > "${WORKDIR}/${PN}.initd" || die "Cannot patch init.d script"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}/"
	for I in "${D}/${INSTALLDIR}/bin"/*; do
		fperms a+x "${INSTALLDIR}/bin/$(basename $I)"
	done
	fperms a+w "${INSTALLDIR}/log/gcal-daemon.log"
	fperms a+w "${INSTALLDIR}/work"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	newinitd "${WORKDIR}/${PN}.initd" ${PN}
}
