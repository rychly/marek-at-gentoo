# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.6"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en_GB es es_LA et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt_BR pt_PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh_CN zh_TW"

inherit chromium eutils multilib portability

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
SRC_URI=

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libudev1hack gnome gnome-keyring"

RDEPEND="app-arch/bzip2
	>=net-print/cups-1.3.11
	>=dev-libs/elfutils-0.149
	dev-libs/expat
	>=dev-libs/nss-3.12.3
	>=gnome-base/gconf-2.24.0
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.28.2 )
	>=media-libs/alsa-lib-1.0.19
	>=media-libs/libjpeg-turbo-1.2.0-r1
	media-libs/libpng
	sys-apps/dbus
	sys-fs/udev
	sys-libs/zlib
	x11-libs/gtk+:2
	x11-libs/libXScrnSaver"
DEPEND="app-arch/unzip"
RDEPEND+="
	!www-client/chromium
	x11-misc/xdg-utils
	virtual/ttf-fonts"

S="${WORKDIR}"

src_unpack() {
	if use amd64; then
		arch_suffix="_x64"
	fi
	#wget -c "https://download-chromium.appspot.com/dl/Linux${arch_suffix}" -O "${T}/${PN}.zip" || die "Download failed"
	cp /tmp/${PN}.zip "${T}"/${PN}.zip
	unzip -qo "${T}/${PN}.zip" -d "${S}" || die "Unpack failed"
	chmod -fR a+rX,u+w,g-w,o-w "${S}/chrome-linux" || die "chmod failed"
}

src_prepare() {
	# Fix required libudev.so.0 by a symlink to libudev.so.1 for >sys-fs/udev-182
	if use libudev1hack; then
		ln -s "/usr/$(get_libdir)/libudev.so.1" "${S}/chrome-linux/libudev.so.0"
		ewarn "Required libudev.so.0 hacked by a symlink to libudev.so.1, this solution may cause serious instabilities!"
	fi
}

src_compile() {
	for I in $(find "${S}/chrome-linux" -perm -u=x -type f); do
		LC_ALL=C LD_LIBRARY_PATH="${S}/chrome-linux:${LD_LIBRARY_PATH}" ldd "$I" \
		| grep '=> not found' && die "Linking error in $I"
	done
}

src_install() {
	local CHROMIUM_NAME="chromium-browser"
	local CHROMIUM_HOME="/opt/${CHROMIUM_NAME}-bin"

	insinto "${CHROMIUM_HOME}"
	doins "${FILESDIR}/chromium-launcher.sh"
	fperms 755 "${CHROMIUM_HOME}/chromium-launcher.sh"
	newman "${S}/chrome-linux/chrome.1" "${CHROMIUM_NAME}.1" && rm "${S}/chrome-linux/chrome.1"
	newicon -s 48 "${S}/chrome-linux/product_logo_48.png" "${CHROMIUM_NAME}.png" && rm "${S}/chrome-linux/product_logo_48.png"

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" "/usr/bin/${CHROMIUM_NAME}" || die
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" "/usr/bin/chromium" || die

	# Allow users to override command-line options, bug #357629.
	insinto "/etc/chromium"
	newins "${FILESDIR}/chromium.default" "default" || die

	pushd "${S}/chrome-linux/locales" > /dev/null || die
	chromium_remove_language_paks
	popd

	mv "${S}/chrome-linux" "${D}${CHROMIUM_HOME}" || die "Unable to install chrome-linux folder"

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		"$CHROMIUM_NAME}" \
		"Chromium" \
		"$CHROMIUM_NAME}" \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"

	# Install GNOME default application entry (bug #303100).
	if use gnome; then
		dodir /usr/share/gnome-control-center/default-apps || die
		insinto /usr/share/gnome-control-center/default-apps
		newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml || die
	fi
}
