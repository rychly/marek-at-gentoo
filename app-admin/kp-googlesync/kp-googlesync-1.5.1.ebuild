# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

DESCRIPTION="Synchronize KeePass database with Google Drive using Google API"
HOMEPAGE="http://sourceforge.net/projects/kp-googlesync/"
SRC_URI="mirror://sourceforge/kp-googlesync/Plugin%20for%20KeePass%202.20.1/GoogleSyncPlugin-${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-admin/keepass"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	insinto "/usr/$(get_libdir)/keepass"
	doins "${S}/GoogleSyncPlugin.plgx" || die "Cannot install the plugin file."
	dodoc "readme.txt" "Sample-KeePass.config.xml"
}

pkg_postinst() {
	einfo ""
	einfo "Please see following link for getting started"
	einfo "	http://sourceforge.net/p/kp-googlesync/support/Getting%20Started/"
	einfo ""
}