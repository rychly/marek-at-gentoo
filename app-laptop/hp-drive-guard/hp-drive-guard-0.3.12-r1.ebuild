# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# based on http://jaybee.cz/software/gentoo-linux/gentoo-on-hp-probook-4530s/

EAPI=2

inherit libtool autotools eutils systemd

DESCRIPTION="HP 3D Drive Guard - Hard disk protection system"
HOMEPAGE="https://build.opensuse.org/package/show/hardware/hp-drive-guard"
SRC_URI="https://build.opensuse.org/source/hardware/hp-drive-guard/${P}.tar.bz2
	https://build.opensuse.org/source/hardware/hp-drive-guard/0001-Fix-misc-compile-warnings.patch
	https://build.opensuse.org/source/hardware/hp-drive-guard/0002-Fix-build-with-the-new-libnotify.patch
	https://build.opensuse.org/source/hardware/hp-drive-guard/use-gtk3.diff
	https://build.opensuse.org/source/hardware/hp-drive-guard/use-new-polkit.diff
	https://build.opensuse.org/source/hardware/hp-drive-guard/hp-drive-guard.service"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-auth/polkit
	x11-libs/libnotify
	|| ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils )
	x11-libs/gtk+:2
	dev-libs/glib:2"
RDEPEND="${DEPEND}"

src_prepare() {
	for PATCH in \
		"0001-Fix-misc-compile-warnings.patch" \
		"0002-Fix-build-with-the-new-libnotify.patch" \
		"use-new-polkit.diff" \
		"use-gtk3.diff" \
	; do epatch "${DISTDIR}/${PATCH}"; done
	epatch "${FILESDIR}/desktop-show.diff"

	AT_M4DIR="." eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		--with-pm=upower \
		--enable-user-setup \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${DISTDIR}/hp-drive-guard.service"
}
