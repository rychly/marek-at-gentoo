# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NAMES="cs-ascii"
NAMEL="czech-ascii"
DESCI="Czech-ASCII"
DESCL="Čeština bez diakritiky"

ASPELL_LANG="${DESCI}"
ASPELL_VERSION=6

inherit aspell-dict-r1

MY_P="aspell6-cs-20040614-1"

SRC_URI="mirror://gnu/aspell/dict/cs/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${MY_P}

RENAMELIST="cs.cwl cs.dat cs.multi cs_affix.dat"
REPLACELIST="${NAMEL}.alias ${NAMES}.multi ${NAMES}.dat"

src_unpack() {
	unpack ${A}
	# rename
	local i
	for i in ${RENAMELIST}; do
		mv -v "${S}/${i}" "${S}/${i//cs/${NAMES}}" || die "Cannot rename '${i}' to ${NAMES}"
	done
	i="czech.alias" && mv -v "${S}/${i}" "${S}/${i//czech/${NAMEL}}" || die "Cannot rename '${i}' to ${NAMES}"
	# replace
	i="info" && sed -i \
		-e "s/Czech/${DESCI}/" \
		-e "s/Čeština/${DESCL}/" \
		-e "s/cs/${NAMES}/g" \
		-e "s/czech/${NAMEL}/" \
		"${S}/${i}" || die "Cannot replace in '${i}' to ${NAMES}"
	for i in ${REPLACELIST}; do
		sed -i "s/cs/${NAMES}/g" "${S}/${i}" || die "Cannot replace in '${i}' to ${NAMES}"
	done
	i="Makefile.pre" && sed -i \
		-e "s/cs/${NAMES}/g" \
		-e "s/czech/${NAMEL}/" \
		"${S}/${i}" || die "Cannot replace in '${i}' to ${NAMES}"
	# recode
	i="Makefile.pre" && sed -i \
		's/\( | ${ASPELL} ${ASPELL_FLAGS} --lang='"${NAMES}"' create master .\/\$@\)/ | iconv -f iso8859-2 -t ASCII\/\/TRANSLIT | sort | uniq\1/' \
		"${S}/${i}" || die "Cannot include recoding in '${i}' to ${NAMES}"
	i="${NAMES}_affix.dat" \
		&& iconv -f iso8859-2 -t ASCII\/\/TRANSLIT "${S}/${i}" > "${S}/${i}.new" \
		&& mv "${S}/${i}.new" "${S}/${i}" || die "Cannot recode '${i}' to ${NAMES}"
}
