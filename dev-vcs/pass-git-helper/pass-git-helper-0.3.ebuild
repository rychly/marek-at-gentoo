# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="A git credential helper interfacing with pass, a standard unix password manager"
HOMEPAGE="https://github.com/languitar/${PN}"
SRC_URI="https://github.com/languitar/${PN}/archive/release-${PV}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND=""
RDEPEND="app-admin/pass
	dev-vcs/git
	|| ( >=dev-lang/python-3 ( dev-lang/python:2.7 dev-python/configparser ) )
	dev-python/pyxdg"

S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	sed -i -e '1s/python3/python/' -e 's/file=\(sys\.stderr\)/\1/' "${PN}"
}

src_install() {
	dobin "${PN}" || die "Could not install the script"
}

pkg_postinst() {
	einfo ""
	einfo "To instruct git to use the helper, set the following configuration option:"
	ewarn "  git config --global credential.helper /usr/bin/${PN}"
	einfo ""
}
