# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="FUSE module to mount camera as filesystem"
HOMEPAGE="http://www.gphoto.org/proj/gphotofs/"
SRC_URI=""

# 0.3: 2006-09-03 13:10
#SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"
#RESTRICT="nomirror"

ESVN_REPO_URI="https://gphoto.svn.sourceforge.net/svnroot/gphoto/trunk/gphotofs"
ESVN_PROJECT="gphotofs"
ESVN_BOOTSTRAP="autoreconf --install --symlink"
ESVN_OPTIONS="--ignore-externals"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# http://gphoto.svn.sourceforge.net/viewvc/gphoto?view=rev&revision=9830
DEPEND=">=sys-fs/fuse-2.4
	>=media-libs/libgphoto2-2.4
"

src_unpack() {
	subversion_fetch
	cd ${S}
	ebegin "Fetching m4m from SVN"
	svn checkout ${ESVN_REPO_URI//gphotofs/m4} m4m || die "unable to fetch m4m"
	eend $? "Failed to fetch m4m from SVN"
	epatch "${FILESDIR}/automake-extra.patch"
	subversion_bootstrap
}

src_install() {
	einstall || die 'Installation failed'
}
