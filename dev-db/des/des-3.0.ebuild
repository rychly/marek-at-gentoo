# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Datalog Educational System (DES) is a Prolog-based basic deductive db system."
HOMEPAGE="http://www.fdi.ucm.es/profesor/fernan/des/"
SRC_URI="mirror://sourceforge/des/DES${PV}SWI.tar.gz"
RESTRICT="mirror"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="compile +examples"

DEPEND="dev-lang/swi-prolog"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	if use compile; then
		# 1st compiling
		sed -i 's|^\(:- initialization((start;true))\.\)|%\1|' "${S}/des.pl"
		cat <<END | swipl
working_directory(_,'${S}').
[des].
END
		# 2nd compiling
		sed -i \
			-e 's|^\(:- initialization(consult(.des_glue.pl.))\.\)|%\1|' \
			-e 's|^\(:- initialization(consult(.des_debug.pl.))\.\)|%\1|' \
			-e 's|^\(:- initialization(consult(.des_sql.pl.))\.\)|%\1|' \
			-e 's|^\(:- initialization(consult(.des_tc.pl.))\.\)|%\1|' \
			"${S}/des.pl"
		cat <<END | swipl
working_directory(_,'${S}').
[des].
qsave_program(des,[goal=start]).
END
	else
		# script
		cat <<END > "${S}/des"
#!/bin/sh
cd "/usr/share/${P}"
exec /usr/bin/swipl -s "/usr/share/${P}/des.pl"
cd -
END
	fi
}

src_install() {
	dodir "/usr/share/${P}" "/usr/share/doc/${P}"
	# Install base
	cp "${S}"/*.pl "${D}/usr/share/${P}" || die "Failed to install files"
	# Install examples
	if use examples; then
		mv "${S}"/examples "${D}/usr/share/doc/${P}" || die "Failed to install examples"
	fi
	# Install documentation
	dodoc doc/* license/* readmeDES${PV}.txt || die "Failed to install documentation"
	# Integration binaries/scripts
	dobin des || die "Failed to install executable"
}
