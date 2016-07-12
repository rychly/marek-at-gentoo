# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit git-2

DESCRIPTION="Mount Android phones on Linux with adb (no root required)"
#SRC_URI="https://github.com/spion/${PN}/archive/master.zip"
EGIT_REPO_URI="https://github.com/spion/${PN}.git"
HOMEPAGE="${EGIT_REPO_URI%.git}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-fs/fuse"
DEPEND="${RDEPEND}"

src_install() {
	dobin adbfs
}
