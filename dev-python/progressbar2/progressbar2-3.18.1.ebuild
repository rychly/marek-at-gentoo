# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3)

inherit distutils-r1

DESCRIPTION="A Python Progressbar library to provide visual (yet text based) progress to long running operations."
HOMEPAGE="https://pypi.python.org/pypi/progressbar2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
