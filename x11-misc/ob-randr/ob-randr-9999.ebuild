# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit git-2

DESCRIPTION="An interactive pipe menu for the OpenBox window manager to allow users easy access to xrandr information and actions."
HOMEPAGE="https://github.com/whiteinge/ob-randr"
EGIT_REPO_URI="https://github.com/whiteinge/ob-randr.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/python
	x11-apps/xrandr"

RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/bin
	newexe ob-randr.py ob-randr || die "Unable to install executable."
}
