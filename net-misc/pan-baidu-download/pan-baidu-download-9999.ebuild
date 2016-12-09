# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit git-2

DESCRIPTION="Baidu network disk download script."
HOMEPAGE="https://github.com/banbanchs/pan-baidu-download"
#SRC_URI="https://github.com/banbanchs/pan-baidu-download/archive/master.zip"
EGIT_REPO_URI="https://github.com/banbanchs/pan-baidu-download.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-lang/python:2.7
	dev-python/requests
	net-misc/aria2"

INSTALLDIR="/opt/${PN}"

src_prepare() {
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "10${PN}"
	# change a storage location to temp directory
	sed -i \
		-e 's/^\(import util\)$/\1\nimport tempfile/' \
		-e "s/os.path.abspath(__file__)/os.path.join(tempfile.gettempdir(), 'none')/g" \
		bddown_core.py command/login.py
}

src_install() {
	insinto "${INSTALLDIR}"
	doins *.py *.ini
	insinto "${INSTALLDIR}/command"
	doins command/*.py
	exeinto "${INSTALLDIR}"
	doexe *_cli.py
	dodoc LICENSE *.md *.txt
	doenvd "10${PN}"
}
