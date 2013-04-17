# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git-2 multilib

DESCRIPTION="KeePass plugin to expose password entries securely (256bit AES/CBC) over HTTP for clients to consume."
HOMEPAGE="https://github.com/pfn/keepasshttp"
EGIT_REPO_URI="git://github.com/pfn/${PN}.git"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-admin/keepass"
DEPEND="${RDEPEND}"

src_compile() {
	DISPLAY=:0 keepass --plgx-create "${S}/KeePassHttp" \
	|| ewarn "Cannot start KeePass to compile the plugin and create *.plgx file. We will use precompiled plugin file instead."
}

src_install() {
	insinto "/usr/$(get_libdir)/keepass"
	doins "${S}/KeePassHttp.plgx" || die "Cannot install the plugin file."
	dodoc "README.md"
}