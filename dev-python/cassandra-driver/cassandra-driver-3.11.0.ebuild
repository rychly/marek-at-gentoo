# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

MY_PN="python-driver"

DESCRIPTION="DataStax Python Driver for Apache Cassandra."
HOMEPAGE="https://github.com/datastax/${MY_PN}"
SRC_URI="https://github.com/datastax/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"
IUSE="cython"

DEPEND="|| ( >=dev-lang/python-3 <=dev-python/futures-2.2.0 )
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	dev-libs/libev
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

python_configure_all() {
	use cython || mydistutilsargs=( --no-cython )
}
