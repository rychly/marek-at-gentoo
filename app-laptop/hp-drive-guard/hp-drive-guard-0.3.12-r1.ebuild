# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# based on http://jaybee.cz/software/gentoo-linux/gentoo-on-hp-probook-4530s/

EAPI=2

inherit libtool autotools eutils

DESCRIPTION="HP 3D Drive Guard - Hard disk protection system"
HOMEPAGE="https://build.opensuse.org/package/files?package=hp-drive-guard&project=hardware"
SRC_URI="https://api.opensuse.org/public/source/hardware/hp-drive-guard/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-auth/polkit
    x11-libs/libnotify
    sys-power/upower
    x11-libs/gtk+:2
    dev-libs/glib:2"
RDEPEND="${DEPEND}"

src_prepare() {
	for PATCH in \
		"0001-Fix-misc-compile-warnings.patch" \
		"0002-Fix-build-with-the-new-libnotify.patch" \
		"use-new-polkit.diff" \
		"desktop-show.diff" \
		"use-gtk3.diff" \
	; do epatch "${FILESDIR}/${PATCH}"; done

	AT_M4DIR="." eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		--with-pm=upower \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}