# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# from https://github.com/rasdark/overlay/tree/master/x11-misc/tint2

EAPI="5"

inherit cmake-utils gnome2-utils git-2

DESCRIPTION="A lightweight panel/taskbar"
HOMEPAGE="https://gitlab.com/o9000/tint2.git"
EGIT_REPO_URI="https://gitlab.com/o9000/tint2.git"
EGIT_BRANCH="master"
EGIT_PROJECT="tint2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="battery examples tint2conf startup-notification"

PDEPEND="tint2conf? ( x11-misc/tintwizard )"

RDEPEND="startup-notification? ( x11-libs/startup-notification )
        dev-libs/glib:2
        media-libs/imlib2[X]
        x11-libs/cairo
        x11-libs/libX11
        x11-libs/libXinerama
        x11-libs/libXdamage
        x11-libs/libXcomposite
        x11-libs/libXrender
        x11-libs/libXrandr
        x11-libs/pango[X]"

DEPEND="${RDEPEND}
        virtual/pkgconfig
        x11-proto/xineramaproto"

PATCHES=( "${FILESDIR}/${PN}-update-icon-cache.patch" )

src_configure() {
        local mycmakeargs=(
                $(cmake-utils_use_enable battery BATTERY)
                $(cmake-utils_use_enable examples EXAMPLES)
                $(cmake-utils_use_enable tint2conf TINT2CONF)
                $(cmake-utils_use_enable startup-notification SN)

                "-DDOCDIR=/usr/share/doc/${PF}"
        )
        cmake-utils_src_configure
}

src_install() {
        cmake-utils_src_install
        if use tint2conf ; then
                gnome2_icon_cache_update
        fi
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
