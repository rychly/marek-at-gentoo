# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# based on
# http://data.gpo.zugaina.org/bgo-overlay/dev-tex/texworks/texworks-0.4.5_p1281.ebuild

EAPI=5

inherit qt4-r2 subversion

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
ESVN_REPO_URI="http://texworks.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+latex"

LANGS="ar ca cs de es fa fr it ja ko nl pl pt_BR ru sl tr zh_CN"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

RDEPEND=">=dev-qt/designer-4.5.2:4
		>=dev-qt/qtcore-4.5.2:4
		>=dev-qt/qtdbus-4.5.2:4
		>=dev-qt/qtgui-4.5.2:4
		>=app-text/poppler-0.12.3-r3[qt4]
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
	cp "${FILESDIR}/TeXworks.desktop" "${S}" || die
}

src_configure() {
	eqmake4 TeXworks.pro
}

src_install() {
	dobin ${PN}

	insinto /usr/share/doc/texworks-help
	doins -r manual/en
	dodoc README PACKAGING NEWS
	doman man/texworks.1

	# install translations
	insinto /usr/share/${PN}/
	for LNG in ${LANGS}; do
		if use linguas_${LNG}; then
			doins trans/TeXworks_${LNG}.qm
		fi
	done
	insinto /usr/share/pixmaps/
	doins res/images/TeXworks.png
	insinto /usr/share/applications/
	doins TeXworks.desktop
}
