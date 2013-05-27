# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME_TARBALL_SUFFIX="xz"

inherit gnome2

DESCRIPTION="A Flickr client for GNOME"
HOMEPAGE="https://live.gnome.org/Frogr"
#SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/frogr/0.8/frogr-0.8.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.32
	media-libs/gstreamer:0.10
	>=x11-libs/gtk+-3.4
	>=dev-libs/json-glib-0.12
	>=media-libs/libexif-0.6.14
	>=net-libs/libsoup-2.26
	>=dev-libs/libxml2-2.6.8
	dev-libs/libgcrypt"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

src_prepare() {
	# Remove stupid CFLAGS, recheck with every bump
	sed -e '/CFLAGS/s/\(-Werror\)\? -g. -O.//' \
		-i configure

	DOCS="AUTHORS COPYING ChangeLog INSTALL MAINTAINERS NEWS README THANKS TRANSLATORS"
	G2CONF="${G2CONF}
		--with-gtk=3.0"

	gnome2_src_prepare
}
