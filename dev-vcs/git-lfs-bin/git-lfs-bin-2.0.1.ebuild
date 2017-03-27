# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Git extension for versioning large files"
HOMEPAGE="https://git-lfs.github.com/"
SRC_URI="x86? ( https://packagecloud.io/github/git-lfs/packages/debian/jessie/git-lfs_${PV}_i386.deb/download -> git-lfs_${PV}_i386.deb )
	amd64? ( https://packagecloud.io/github/git-lfs/packages/debian/jessie/git-lfs_${PV}_amd64.deb/download -> git-lfs_${PV}_amd64.deb )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RESTRICT="mirror"
DEPEND="!dev-vcs/git-lfs"
RDEPEND="dev-vcs/git"

src_unpack() {
	unpack ${A}
	tar -xJf "${WORKDIR}/data.tar.xz"
}

src_install() {
	dobin usr/bin/git-lfs
	dodoc usr/share/doc/git-lfs/{changelog.gz,copyright}
	doman usr/share/man/man1/*.1.*
}
