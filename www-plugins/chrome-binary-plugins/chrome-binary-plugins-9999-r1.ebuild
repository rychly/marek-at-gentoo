# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Binary plugins from Google Chrome for use in Chromium."
HOMEPAGE="http://www.google.com/chrome"
URI_BASE="https://dl.google.com/linux/direct/"
URI_BASE_NAME="google-chrome-unstable_current_"
SRC_URI="" # URI is left blank on live ebuild
RESTRICT="mirror strip"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="~x86 ~amd64" # KEYWORDS is also left blank on live ebuild
IUSE="+flash +pdf"

DEPEND="|| ( www-client/chromium www-client/chromium-bin )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/opt/google/chrome"

inherit unpacker

src_unpack() {
	# We have to do this inside of here, since it's a live ebuild. :-(

	if use x86; then
		G_ARCH="i386";
	elif use amd64; then
		G_ARCH="amd64";
	else
		die "This only supports x86 and amd64."
	fi
	wget "${URI_BASE}${URI_BASE_NAME}${G_ARCH}.deb"
	unpack_deb "./${URI_BASE_NAME}${G_ARCH}.deb"
}

src_install() {
	local version flapper

	insinto /usr/lib/chromium-browser/

	if use pdf; then
		doins libpdf.so
		[ -d /opt/chromium-browser-bin/chrome-linux ] && \
		dosym /usr/lib/chromium-browser/libpdf.so /opt/chromium-browser-bin/chrome-linux/libpdf.so
	fi

	if use flash; then
		doins -r PepperFlash

		# Since this is a live ebuild, we're forced to, unfortuantely,
		# dynamically construct the command line args for Chromium.
		version=$(sed -n 's/.*"version": "\(.*\)",.*/\1/p' PepperFlash/manifest.json)
		flapper="${ROOT}usr/lib/chromium-browser/PepperFlash/libpepflashplayer.so"
		echo -n "CHROMIUM_FLAGS=\"\${CHROMIUM_FLAGS} " > pepper-flash
		echo -n "--ppapi-flash-path=$flapper " >> pepper-flash
		echo "--ppapi-flash-version=$version\"" >> pepper-flash

		insinto /etc/chromium/
		doins pepper-flash
	fi
}
pkg_postinst() {
	use flash || return

	einfo
	einfo "To enable Flash for Chromium, source	${ROOT}etc/chromium/pepper-flash"
	einfo "inside ${ROOT}etc/chromium/default. You may run this as root:"
	einfo
	einfo "  # echo . ${ROOT}etc/chromium/pepper-flash >> ${ROOT}etc/chromium/default"
	einfo
}
