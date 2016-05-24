# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit git-2

DESCRIPTION="Hook program for gitannex to use mega.co.nz as backend"
HOMEPAGE="https://github.com/TobiasTheViking/megaannex https://git-annex.branchable.com/tips/megaannex/"
#SRC_URI="https://github.com/TobiasTheViking/megaannex/archive/master.zip"
EGIT_REPO_URI="https://github.com/TobiasTheViking/megaannex.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-lang/python:2.7
	>=dev-python/requests-0.10
	dev-python/pycrypto"

INSTALLDIR="/opt/${PN}"

src_prepare() {
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "10${PN}"
}

src_install() {
	insinto "${INSTALLDIR}"
	doins *.md
	insinto "${INSTALLDIR}/lib"
	doins lib/*.py
	exeinto "${INSTALLDIR}"
	doexe "${PN}"
	doenvd "10${PN}"
}

pkg_postinst() {
	einfo ""
	einfo "To set up git-annex to use mega.co.nz as backend run:"
	ewarn "  USERNAME='user' PASSWORD='password' git annex initremote mega type=external externaltype=mega encryption=none folder=git-annex"
	ewarn "  git annex describe mega 'Mega.nz'"
	einfo "Please note that the remote folder (set to 'git-annex' in the example above) has to exists already in your Mega.nz storage."
	einfo ""
}
