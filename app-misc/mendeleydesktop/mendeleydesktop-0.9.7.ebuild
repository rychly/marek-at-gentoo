# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A free research management tool for desktop & web"
HOMEPAGE="http://www.mendeley.com/"
SRC_URI="x86? ( http://www.mendeley.com/downloads/linux/${P}-linux-i486.tar.bz2 )
	amd64? ( http://www.mendeley.com/downloads/linux/${P}-linux-x86_64.tar.bz2 )"

LICENSE="Mendelay-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
RDEPEND="=media-libs/libpng-1.2*"

if [ "${ARCH}" = "amd64" ] ; then
	S="${WORKDIR}/${P}-linux-x86_64"
else
	S="${WORKDIR}/${P}-linux-i486"
fi

MENDELEY_INSTALL_DIR="/opt/${PN}"

src_install() {
	# install menu
	domenu ${S}/share/applications/${PN}.desktop || die "Installing desktop files failed."
	# Install commonly used icon sizes
	for res in 16x16 22x22 32x32 48x48 64x64 128x128 ; do
		insinto /usr/share/icons/hicolor/${res}/apps
		doins share/icons/hicolor/${res}/apps/${PN}.png || die "Installing icons failed."
	done
	insinto /usr/share/pixmaps
	doins share/icons/hicolor/48x48/apps/${PN}.png || die "Installing pixmap failed."

	# dodoc
	dodoc ${S}/share/doc/${PN}/* || die "Installing docs failed."

	dodir ${MENDELEY_INSTALL_DIR}
	dodir ${MENDELEY_INSTALL_DIR}/lib
	dodir ${MENDELEY_INSTALL_DIR}/share
	#mv ${S}/share/icons ${D}/usr/share
	mv ${S}/bin ${D}${MENDELEY_INSTALL_DIR} || die "Installing bin failed."
	mv ${S}/lib ${D}${MENDELEY_INSTALL_DIR} || die "Installing libs failed."
	mv ${S}/share/${PN} ${D}${MENDELEY_INSTALL_DIR}/share || die "Installing shared files failed."

	dosym /opt/${PN}/bin/${PN} /opt/bin/${PN} || die "Installing launcher symlinks failed."
}

pkg_postinst() {
	einfo "If you have an error message \"Cannot mix incompatible Qt libraries\","
	einfo "when you run mendeleydesktop, follow the instructions below:"
	echo
	einfo "- To disable the default widget style, run Mendeley with the "
	einfo "'-style cleanlooks' argument (where 'cleanlooks' can also be substituted"
	einfo "with 'gtk' or 'plastique' amongst others)."
	echo
	einfo "- To disable the 'platform integration' plugin (new feature in Qt >= 4.6),"
	einfo "set the QT_PLATFORM_PLUGIN environment variable to some nonsense value "
	einfo "(eg. \"ignoreme\") before running Mendeley."
}
