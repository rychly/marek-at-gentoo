# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# based on
# http://data.gpo.zugaina.org/bgo-overlay/dev-tex/texworks/texworks-0.4.4_p1004.ebuild

EAPI="2"

inherit qt4-r2 subversion

DESCRIPTION="Environment for authoring TeX/LaTeX/ConTeXt with focus on usability"
HOMEPAGE="http://code.google.com/p/texworks"
ESVN_REPO_URI="http://texworks.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex"

LANGS="ar ca cs de es fa fr it ja ko nl pl pt_BR ru sl tr zh_CN"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

RDEPEND=">=dev-qt/qtcore-4.5:4
		|| ( >=dev-qt/qtgui-4.5:4[dbus]
			( >=dev-qt/qtgui-4.8:4 >=dev-qt/qtdbus-4.8:4 )
		)
		app-text/poppler[qt4]
		>=app-text/hunspell-1.2.8"
DEPEND="${RDEPEND}"
PDEPEND="latex? ( dev-texlive/texlive-latex )
	!latex? ( app-text/texlive-core )"

src_prepare() {
	# disable guessing path to tex binary, we already know it
	sed -i '\:system(./getDefaultBinPaths.sh): d' TeXworks.pro || die
	echo '#define DEFAULT_BIN_PATHS "/usr/bin"' > src/DefaultBinaryPaths.h || die

	sed -i '/INSTALL_PREFIX/ s:/usr/local:/usr:' TeXworks.pro || die
	sed -i '/TW_HELPPATH/ s:DATA_DIR/texworks-help:DATA_DIR/doc/texworks-help:' TeXworks.pro || die
	sed -i '/TW_DICPATH/ s:/usr/share/myspell/dicts:/usr/share/myspell:' TeXworks.pro || die
	cp "${FILESDIR}/texworks.desktop" "${S}" || die
}

src_configure() {
	eqmake4 TeXworks.pro
}

src_install() {
	dobin ${PN} || die

	insinto /usr/share/doc/texworks-help
	doins -r manual/en
	dodoc README PACKAGING COPYING NEWS
	doman man/texworks.1

	# install translations
	insinto /usr/share/${PN}/
	for LNG in ${LANGS}; do
		if use linguas_${LNG}; then
			doins trans/TeXworks_${LNG}.qm || die
		fi
	done
	insinto /usr/share/pixmaps/
	doins res/images/TeXworks.png || die
	insinto /usr/share/applications/
	doins texworks.desktop || die
}
