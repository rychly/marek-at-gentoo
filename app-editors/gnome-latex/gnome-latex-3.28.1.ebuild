# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# adopted from https://data.gpo.zugaina.org/gnome/app-editors/latexila/

EAPI="6"
VALA_MIN_API_VERSION="0.34"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Integrated LaTeX environment for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/GNOME-LaTeX"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection +latexmk rubber"

COMMON_DEPEND="
	$(vala_depend)
	app-text/enchant
	>=app-text/gspell-1.0:0=
	>=dev-libs/glib-2.56:2[dbus]
	>=dev-libs/libgee-0.10:0.8=
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/gtksourceview-4.01:4.0=
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	x11-libs/tepl:4
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	x11-themes/hicolor-icon-theme
	latexmk? ( dev-tex/latexmk )
	rubber? ( dev-tex/rubber )
"
# libxml2+gdk-pixbuf required for glib-compile-resources
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
}
