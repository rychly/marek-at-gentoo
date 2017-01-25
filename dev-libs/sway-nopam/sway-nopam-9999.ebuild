# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 eutils cmake-utils fcaps

DESCRIPTION="Sway (i3-compatible Wayland compositor) fork: swaylock without PAM dependency."
HOMEPAGE="https://github.com/rychly/sway-nopam"

EGIT_REPO_URI="https://github.com/rychly/sway-nopam.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+swaybg +swaybar +swaymsg swaygrab +swaylock +gdk-pixbuf zsh-completion wallpapers systemd"

RDEPEND="=dev-libs/wlc-9999[systemd=]
		dev-libs/json-c
		dev-libs/libpcre
		dev-libs/libinput
		x11-libs/libxkbcommon
		dev-libs/wayland
		sys-libs/libcap
		x11-libs/pango
		x11-libs/cairo
		gdk-pixbuf? ( x11-libs/gdk-pixbuf[jpeg] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
		app-text/asciidoc"

src_prepare() {
	cmake-utils_src_prepare

	# remove bad CFLAGS that upstream is trying to add
	sed -i -e '/FLAGS.*-Werror/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-swaybar=$(usex swaybar)
		-Denable-swaybg=$(usex swaybg)
		-Denable-swaygrab=$(usex swaygrab)
		-Denable-swaylock=$(usex swaylock)
		-Denable-swaymsg=$(usex swaymsg)

		-Ddefault-wallpaper=$(usex wallpapers)

		-Denable-gdk-pixbuf=$(usex gdk-pixbuf)
		-Dzsh-completions=$(usex zsh-completion)

		-DCMAKE_INSTALL_SYSCONFDIR="/etc"
		-DLD_LIBRARY_PATH="${EPREFIX}/usr/lib"
	)

	cmake-utils_src_configure
}

FILECAPS=( -M 4711 cap_sys_ptrace,cap_sys_tty_config usr/bin/sway )

pkg_postinst() {
	fcaps_pkg_postinst
	if use swaygrab
	then
		optfeature "swaygrab screenshot support" media-gfx/imagemagick[png]
		optfeature "swaygrab video capture support" virtual/ffmpeg
	fi
	optfeature "X11 applications support" dev-libs/wlc[xwayland] x11-base/xorg-server[wayland]
}
