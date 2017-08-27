# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit git-2

DESCRIPTION="GNU Privacy Guard-encrypted git remote"
HOMEPAGE="https://spwhitton.name/tech/code/git-remote-gcrypt/"
#SRC_URI="https://git.spwhitton.name/${PN}/snapshot/${P}.tar.gz"
EGIT_REPO_URI="https://git.spwhitton.name/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/docutils"
RDEPEND="dev-vcs/git"

src_install() {
	dobin "${PN}" || die "Cannot install a script"
	rst2man.py README.rst > "${PN}.1" && doman "${PN}.1" || die "Cannot install a man-page"
}
