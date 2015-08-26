# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# from https://github.com/rasdark/overlay/tree/master/x11-misc/obdevicemenu with modified SRC_URI and install paths

EAPI="2"

DESCRIPTION="OpenBox device menu"
HOMEPAGE="http://sourceforge.net/projects/obdevicemenu/"
SRC_URI="https://aur.archlinux.org/cgit/aur.git/snapshot/obdevicemenu.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notifications"
RESTRICT="mirror"

DEPEND="
	app-shells/bash
	sys-apps/dbus
	x11-wm/openbox
	sys-fs/udisks
	notifications? ( x11-misc/notification-daemon )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /etc
	doins obdevicemenu.conf || die "Unable to install config file."
	exeinto /usr/bin
	doexe obdevicemenu || die "Unable to install executable."
}
