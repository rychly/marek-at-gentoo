# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1

DESCRIPTION="manage files with git, without checking their contents into git"
HOMEPAGE="http://git-annex.branchable.com/"
SRC_URI="x86? ( http://ftp.sh.cvut.cz/arch/community/os/i686/${PN%-bin}-${PV/_p/-}-i686.pkg.tar.xz )
	amd64? ( http://ftp.sh.cvut.cz/arch/community/os/x86_64/${PN%-bin}-${PV/_p/-}-x86_64.pkg.tar.xz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
RESTRICT="mirror"

DEPEND="!dev-vcs/git-annex"
RDEPEND="net-libs/libgsasl
	net-dns/libidn
	sys-apps/file
	net-libs/gnutls:0/30
	dev-libs/libxml2
	sys-libs/zlib
	dev-libs/gmp
	dev-libs/libffi"

S="${WORKDIR}"

src_install() {
	dobin usr/bin/git-annex
	dosym git-annex /usr/bin/git-annex-shell
	newbashcomp usr/share/bash-completion/completions/git-annex "${PN%-bin}"
	doman usr/share/man/man1/*.1.*
	doicon "${FILESDIR}/${PN%-bin}.xpm"
	make_desktop_entry "${PN%-bin} webapp" "git-annex" "${PN%-bin}" "Office"
}

pkg_postinst() {
	einfo ""
	einfo "To set the default web-browser for git-annex webapp, config the corresponding git variables, e.g.,"
	ewarn "  git config --global web.browser google-chrome-stable"
	einfo ""
}
