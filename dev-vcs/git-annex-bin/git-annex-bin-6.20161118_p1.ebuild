# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1 unpacker

DESCRIPTION="manage files with git, without checking their contents into git"
HOMEPAGE="http://git-annex.branchable.com/"
SRC_URI="x86? ( mirror://debian/pool/main/${PN:0:1}/${PN%-bin}/${PN%-bin}_${PV/_p/-}_i386.deb )
	amd64? ( mirror://debian/pool/main/${PN:0:1}/${PN%-bin}/${PN%-bin}_${PV/_p/-}_amd64.deb )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
RESTRICT="mirror"

DEPEND="!dev-vcs/git-annex"
RDEPEND="dev-libs/gmp
	virtual/libffi
	dev-libs/libxml2
	net-dns/libidn
	net-libs/gnutls:0/30
	net-libs/libgsasl
	sys-apps/file
	sys-libs/zlib"

S="${WORKDIR}"

src_install() {
	dobin usr/bin/git-annex
	dosym git-annex /usr/bin/git-annex-shell
	newbashcomp usr/share/bash-completion/completions/git-annex "${PN%-bin}"
	doman usr/share/man/man1/*.1.*
	for I in usr/share/icons/hicolor/*; do
		local BASENAME="${I##*/}"
		doicon -s "${BASENAME%x*}" ${I}/apps/git-annex.*
	done
	make_desktop_entry "${PN%-bin} webapp" "git-annex" "${PN%-bin}" "Office"
}

pkg_postinst() {
	einfo ""
	einfo "To set the default web-browser for git-annex webapp, config the corresponding git variables, e.g.,"
	ewarn "  git config --global web.browser google-chrome-stable"
	einfo ""
}
