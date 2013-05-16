# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# based on
# http://data.gpo.zugaina.org/bgo-overlay/www-client/chromium-bin-debian/chromium-bin-debian-26.0.1410.43_p1.ebuild

EAPI="3"

inherit multilib

MY_PV=${PV/_p/-}

DESCRIPTION="Chromium build from Debian unstable"
HOMEPAGE="http://packages.debian.org/sid/chromium"
SRC_URI="x86? ( mirror://debian/pool/main/${PN:0:1}/${PN:0:8}-browser/${PN:0:8}_${MY_PV}_i386.deb )
	amd64? ( mirror://debian/pool/main/${PN:0:1}/${PN:0:8}-browser/${PN:0:8}_${MY_PV}_amd64.deb )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="libudev1hack"

UDEV_V=198

DEPEND=""
RDEPEND="
	app-accessibility/speech-dispatcher
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libevent
	dev-libs/libgcrypt
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	gnome-base/libgnome-keyring
	media-libs/alsa-lib
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libvpx
	media-libs/speex
	>=media-sound/pulseaudio-2.0
	net-print/cups
	sys-apps/dbus
	>=sys-apps/systemd-${UDEV_V}
	>=sys-devel/gcc-4.6[cxx]
	>=sys-fs/udev-${UDEV_V}
	virtual/jpeg
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	"

src_unpack() {
	unpack "${A}"
	tar -C "${WORKDIR}" -xzf "${WORKDIR}/control.tar.gz" && rm "${WORKDIR}/control.tar.gz"
	tar -C "${WORKDIR}" -xzf "${WORKDIR}/data.tar.gz" && rm "${WORKDIR}/data.tar.gz"
}


src_prepare() {
	# Fix required libudev.so.0 by a symlink to libudev.so.1 for >sys-fs/udev-182
	if use libudev1hack; then
		( [[ -e "/usr/$(get_libdir)/libudev.so.1" ]] \
			&& ln -s "/usr/$(get_libdir)/libudev.so.1" "${S}/chrome-linux/libudev.so.0" ) \
		|| ( [[ -e "/$(get_libdir)/libudev.so.1" ]] \
			&& ln -s "/$(get_libdir)/libudev.so.1" "${S}/chrome-linux/libudev.so.0" ) \
		|| die "Cannot find libudev.so.1 to be symlinked to libudev.so.0!"
		ewarn "Required libudev.so.0 hacked by a symlink to libudev.so.1, this solution may cause serious instabilities!"
	fi
}

src_install() {
	mv "${WORKDIR}/etc" "${WORKDIR}/usr" "${D}" || die

	if [[ "$(get_libdir)" != "lib" ]]; then
		mv "${D}/usr/lib" "${D}/usr/$(get_libdir)" || die
	fi

	echo sid > "${D}"/etc/debian_version || die
}
