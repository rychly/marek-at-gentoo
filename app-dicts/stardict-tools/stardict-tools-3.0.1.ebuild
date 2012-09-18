# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="3"

inherit eutils autotools

IUSE="+editor +tools"
DESCRIPTION="Stardict tools"
HOMEPAGE="https://code.google.com/p/stardict-3/"
SRC_URI="https://stardict-3.googlecode.com/files/${P}.tar.bz2"

RESTRICT="test mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 sparc ~x86"

RDEPEND="sys-libs/zlib
	dev-libs/libsigc++
	>=x11-libs/gtk+-2.12"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.22
	dev-util/pkgconfig"

pkg_setup() {
	if ! use editor && ! use tools; then
		eerror "at least one use-flag should be enabled"
		die "nothing selected for installation"
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/nomysql.patch" || die "Cannot apply a patch"
	epatch "${FILESDIR}/gcc43.patch" || die "Cannot apply a patch"
}

src_install() {
	if use editor; then
		emake DESTDIR="${D}" install || die "failed to install editor"
	fi

	local UTIL_LIST="21shiji 21tech babylon bgl2txt buddhist cedict degb2utf dictbuilder
			dictd2dic dictd2dic.sh directory2dic directory2treedic downloadwiki
			dsl2dict duden ec50 edict exc2i2e exc.sh extractKangXi.py fest2dict
			frgb2utf gmx2utf hanzim2dict.py i2e2dict i2e.sh jdictionary jm2stardict.py
			jpgb2utf KangXi kanjidic2 kdic kingsoft lingea-trd-decoder.py makevietdict.py
			mkguangyunst.py mova myspell2dic myspell.sh ncce2stardict.pl olddic2newdic
			ooo2dict ooo.sh oxford2dic parse-oxford.perl powerword pydict2dic rucn
			soothill stmerge.py tabfile tabfile2sql testutf8 treedict2dir Unihan
			uyghur2dict.py wikipedia wikipediaImage wordnet wquick2dic wubi xiaoxuetang-ja
			xmlinout ydp2dict"
	local UTIL_LIST_EXCEPTIONS="stardict2txt stardict_dict_update stardict_verify"
	if use tools; then
		ebegin "installing console stardict tools:"
		    for i in $UTIL_LIST; do
			    einfo "${i} as stardict_$i"
			    newbin src/"${i}" "stardict_${i}" || die "failed to install tools"
		    done
		    for i in $UTIL_LIST_EXCEPTIONS; do
			    einfo "${i} as $i"
			    dobin src/"${i}" || die "failed to install tools"
		    done
		eend "$?"
	fi
}

pkg_postinst() {
	if use tools; then
		ewarn "some tools may need some other additional packages installed to function"
		ewarn "especially python scripts"
	fi
}
