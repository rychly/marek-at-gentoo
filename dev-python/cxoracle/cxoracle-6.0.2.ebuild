# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# adopted from https://data.gpo.zugaina.org/pentoo/dev-python/cxoracle/cxoracle-5.3.ebuild

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
inherit distutils-r1

MY_PN="cx_Oracle"
DESCRIPTION="Python extension module that allows access to Oracle Databases"
HOMEPAGE="http://www.python.net/crew/atuining/cx_Oracle/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test doc"

DEPEND=">=dev-db/oracle-instantclient-11.2.0.2[sdk]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	distutils-r1_src_install
	if use test;then
		docinto tests/
		dodoc test/*
	fi
	if use doc;then
		dodoc html/*
	fi
}
