# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit git-2 multilib

DESCRIPTION="KeePass plugin to expose password entries over HTTP for clients to consume"
HOMEPAGE="https://github.com/pfn/keepasshttp"
EGIT_REPO_URI="git://github.com/pfn/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="binary"

RDEPEND="app-admin/keepass"
DEPEND="dev-lang/mono
	${RDEPEND}"

src_prepare() {
	sed -i "s|<HintPath>[^<]*KeePass.exe</HintPath>|<HintPath>/usr/$(get_libdir)/keepass/KeePass.exe</HintPath>|g" KeePassHttp/KeePassHttp.csproj
}

src_compile() {
	if ! use binary; then
		cd KeePassHttp
		xbuild /target:clean KeePassHttp.csproj
		xbuild /property:Configuration=Release KeePassHttp.csproj || die "Cannot compile the plugin (you can enable 'binary' USE flag to use an official upstream pre-built binary of the plugin)"
	fi
}

src_install() {
	insinto "/usr/$(get_libdir)/keepass"
	if use binary; then
		doins KeePassHttp.plgx || die "Cannot install the pre-built binary of the plugin file"
	else
		doins KeePassHttp/bin/Release/{KeePassHttp.dll,Newtonsoft.Json.dll} || die "Cannot install the built binary of the plugin file"
	fi
	dodoc "README.md"
}
