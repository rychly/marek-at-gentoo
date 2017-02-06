# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="gtk? 2:2.6"

inherit eutils gnome2-utils python autotools

DESCRIPTION="A screen color temperature adjusting software (with Wayland patches)"
HOMEPAGE="http://jonls.dk/redshift/"
SRC_URI="https://launchpad.net/${PN%-wl}/trunk/${PV}/+download/${P/-wl}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="geoclue gnome gtk nls"
RESTRICT="mirror"

COMMON_DEPEND=">=x11-libs/libX11-1.4
	x11-libs/libXxf86vm
	x11-libs/libxcb
	geoclue? ( app-misc/geoclue:0 )
	gnome? ( dev-libs/glib:2
		>=gnome-base/gconf-2 )"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/redshift
	gtk? ( >=dev-python/pygtk-2
		dev-python/pyxdg )"
DEPEND="${COMMON_DEPEND}
	sys-devel/automake:1.12
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${P/-wl}"

pkg_setup() {
	use gtk && python_set_active_version 2
}

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}" EPATCH_SUFFIX="patch" EPATCH_FORCE="no" epatch
	eautoreconf
	if use gtk; then
		>py-compile
		python_convert_shebangs 2 src/redshift-gtk/redshift-gtk
	fi
}

src_configure() {
	local myconf
	use gtk || myconf="--disable-gui"

	econf \
		--disable-dependency-tracking \
		$(use_enable nls) \
		--enable-randr \
		--enable-vidmode \
		$(use_enable gnome gnome-clock) \
		$(use_enable geoclue) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	use gtk && python_mod_optimize ${PN%-wl}_gtk
}

pkg_postrm() {
	gnome2_icon_cache_update
	use gtk && python_mod_cleanup ${PN%-wl}_gtk
}
