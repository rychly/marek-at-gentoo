# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit git-2 user udev

DESCRIPTION="Udev rules to connect Android devices to your linux box."
#SRC_URI="https://github.com/M0Rf30/android-udev-rules/archive/${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/M0Rf30/android-udev-rules.git"
HOMEPAGE="${EGIT_REPO_URI%.git}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/udev
	media-libs/libmtp"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup adbusers
}

src_install() {
	udev_dorules 51-android.rules
}

pkg_postinst() {
	udev_reload
}
