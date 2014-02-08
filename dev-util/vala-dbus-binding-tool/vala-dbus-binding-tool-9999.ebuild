# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

VALA_MIN_API_VERSION=0.11

inherit base git-2 autotools vala

DESCRIPTION="A tool to create gobject interfaces out of DBus XML specifications."
HOMEPAGE="http://wiki.freesmartphone.org/index.php/Implementations/vala-dbus-binding-tool"

EGIT_REPO_URI="git://git.freesmartphone.org/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18.0
	>=dev-libs/libgee-0.6.0"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	eautoreconf
}

src_prepare() {
	base_src_prepare
	vala_src_prepare
}