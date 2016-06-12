# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 waf-utils

DESCRIPTION="Toolkit for flashing Linux kernel images to rk3066/rk3188/rk3288 based devices"
HOMEPAGE="https://github.com/linuxerwang/rkflashkit"
COMMIT_ID="19f45de3c65faa0e3bc9ea595349676a85f03ef9"
SRC_URI="https://github.com/linuxerwang/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}/${PN}-${COMMIT_ID}

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	virtual/libusb:1
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

NO_WAF_LIBDIR=1

src_prepare() {
	sed -i -e "s#debian/usr/share#usr/share#" -e "s/0.1.0/${PV}/" wscript || die
	sed -i -e "s#src#/usr/share/rkflashkit/lib/#" run.py || die
}

src_install() {
	waf-utils_src_install
	python_newscript run.py ${PN}
	mv "${S}/debian/usr/share/rkflashkit/images" "${D}/usr/share/rkflashkit/"
	dodir "/usr/share/applications"
	sed \
		-e 's/rkflashkit-pkexec/rkflashkit/g' \
		-e 's/Application;//g' \
		"${S}/debian/usr/share/applications/rkflashkit.desktop" >"${D}/usr/share/applications/${PN}.desktop"
}
