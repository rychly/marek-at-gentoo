# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# http://bugs.gentoo.org/show_bug.cgi?id=96328

inherit eutils

DESCRIPTION="SMBNetFS is a Linux/FreeBSD filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
HOMEPAGE="http://sourceforge.net/projects/smbnetfs"
SRC_URI="mirror://sourceforge/smbnetfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
RESTRICT="mirror"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.3
	 >=net-fs/samba-3.0.21
	 sys-devel/autoconf
	 sys-devel/automake"

DEPEND="${RDEPEND}
	virtual/libc
	sys-devel/libtool
	sys-devel/make"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:docdir = \$(datadir)/doc/smbnetfs:docdir = \$(datadir)/doc/${P}:" Makefile.in
	./autogen.sh || die "./autogen.sh failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	rm -rf ${D}/usr/share/doc/smbnetfs
	dodoc COPYING AUTHORS ChangeLog README INSTALL RUSSIAN.FAQ
	dodoc doc/smbnetfs.conf
}

pkg_postinst() {
	einfo ""
	einfo "For quick usage, exec:"
	einfo "'modprobe fuse'"
	einfo "'smbnetfs -oallow_other /mnt/samba'"
	einfo ""
}
