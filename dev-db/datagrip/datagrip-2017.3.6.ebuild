# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils readme.gentoo-r1 xdg

DESCRIPTION="A database IDE that is tailored to suit specific needs of professional SQL developers"
HOMEPAGE="http://www.jetbrains.com/datagrip/"
SRC_URI="http://download.jetbrains.com/datagrip/${P}.tar.gz"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.8"

RESTRICT="mirror strip"

QA_PREBUILT="opt/${PN}/bin/fsnotifier
	opt/${PN}/bin/fsnotifier64
	opt/${PN}/bin/fsnotifier-arm
	opt/${PN}/bin/libyjpagent-linux.so
	opt/${PN}/bin/libyjpagent-linux64.so"

S="${WORKDIR}/DataGrip-${PV}"

src_prepare() {
	default

	rm -rf jre{,64} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/{datagrip.sh,fsnotifier{,64},inspect.sh}

	dosym ../../opt/${PN}/bin/datagrip.sh /usr/bin/${PN}
	newicon bin/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
