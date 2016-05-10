# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Pi Calculus Equivalences Tester of types of behavioural equivalences (binary version)."
HOMEPAGE="http://piet.sourceforge.net/"
# the unversioned download, patch level set according to "updated" information on http://piet.sourceforge.net/#download
SRC_URI="mirror://sourceforge/piet/binaries_linux.zip -> ${P}.zip"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gui"
RESTRICT="nomirror"

DEPEND=""
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"
INSTALLDIR="/opt/${PN}"

src_install() {
	dodir "${INSTALLDIR}"
	if use gui; then
		mv "${S}"/*.jar "${D}${INSTALLDIR}" || die "Cannot install gui"
		cp "${FILESDIR}/piet-gui.sh" "${D}${INSTALLDIR}/piet-gui" || die "Cannot install gui wrapper"
		fperms a+x "${INSTALLDIR}/piet-gui"
	fi
	mv "${S}/piet" "${D}${INSTALLDIR}" || die "Cannot install core"
	fperms a+x "${INSTALLDIR}/piet"
	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
