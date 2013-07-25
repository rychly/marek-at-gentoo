# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Scripts for decoding Lingea Dictionary (.trd) file."
HOMEPAGE="https://code.google.com/p/lingea-trd-decoder/"
SRC_URI=""

LICENSE="BSP"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd" # the same as for dev-lang/python:2.*
IUSE=""
SLOT="0"

RDEPEND="=dev-lang/python-2*
	app-arch/bzip2"

src_install() {
	dodir "/usr/bin"
	cp "${FILESDIR}/lingea-decode-trd-dir.sh" "${D}/usr/bin/lingea-decode-trd-dir"
	cp "${FILESDIR}/lingea-trd-decoder.py" "${D}/usr/bin/lingea-trd-decoder"
	fperms 755 "/usr/bin/lingea-decode-trd-dir"
	fperms 755 "/usr/bin/lingea-trd-decoder"
}
