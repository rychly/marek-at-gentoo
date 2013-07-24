# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="Clearlooks With a Cherry on Top theme for MetaCity/Mutter."
THEME_URI="http://ftp.gnome.org/pub/GNOME/teams/art.gnome.org/themes/metacity/"
SRC_URI="${THEME_URI}MCity-ClearlooksWithACherryOnTop.tar.gz"

HOMEPAGE="http://art.gnome.org/themes/metacity/1256"

RDEPEND="|| ( x11-wm/metacity x11-wm/mutter )"
DEPEND="${RDEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/ClearlooksWithACherryOnTop"

src_prepare() {
	cp "${FILESDIR}/index.theme" "${S}"
	find "${S}" -type f -iname "*.*~" -exec rm "{}" \;
	find "${S}" -exec touch "{}" \;
	chmod -R ugo=rX "${S}"/*
}

src_install() {
	dodir /usr/share/themes
	insinto /usr/share/themes
	doins -r "${S}"
}
