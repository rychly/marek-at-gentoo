# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="Czech Television RTMP URL extractor."
HOMEPAGE="http://xpisar.wz.cz/"
SRC_URI="http://xpisar.wz.cz/ctstream/ctstream-${PV}"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd" # the same as for dev-lang/perl

RDEPEND="dev-lang/perl
	dev-perl/HTTP-Message
	dev-perl/XML-XPath
	dev-perl/URI
	dev-perl/JSON"

DEPEND="${RDEPEND}"

src_install() {
	exeinto "/usr/bin"
	newexe "${DISTDIR}/${A}" "${PN}" || die "Cannot install the script!"
}
