# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A replacement set of images and CSS code for the Firefox widgets which will make them much nicer on the eyes."
HOMEPAGE="http://ubuntuforums.org/showpost.php?p=2206886&postcount=1"
SRC_URI="${P//-/_}.tar.bz2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=www-client/mozilla-firefox-2"
RESTRICT="fetch"

S="${WORKDIR}/${P//-/_}"
INSTALLDIR="/usr/lib64/mozilla-firefox"

pkg_nofetch() {
	einfo
	einfo " Because of license terms and file name conventions, please:"
	einfo
	einfo " 1. Visit ${HOMEPAGE}"
	einfo "    (you may need to create an account)"
	einfo " 2. Download the appropriate file:"
	einfo "    ${SRC_URI}"
	einfo " 3. Place the files in ${DISTDIR}"
	einfo " 4. Resume the installation."
	einfo
}

src_unpack() {
	unpack ${A}
	## remove sudo calls
	sed 's/sudo //g' "${S}/install" >"${S}/install.new"
}

src_install() {
	insinto "${INSTALLDIR}/res"
	doins "${INSTALLDIR}/res/forms.css"
	cp -v "${INSTALLDIR}/res"/forms.css.without-${PN}-* "${D}${INSTALLDIR}/res/forms.css.without-${P}" \
	|| cp -v "${INSTALLDIR}/res/forms.css" "${D}${INSTALLDIR}/res/forms.css.without-${P}" || die "Cannot backup old forms.css!"
	cd ${S}; "${S}/install" "-p=${D}${INSTALLDIR}" -i || die "Cannot install!"
	mv "${D}${INSTALLDIR}/res/forms.css" "${D}${INSTALLDIR}/res/forms.css.with-${P}"
}

pkg_postinst() {
	elog
	elog  " You need to replace an old CSS code for forms with a new one"
	ewarn "	mv ${INSTALLDIR}/res/forms.css.with-${P} ${INSTALLDIR}/res/forms.css"
	elog  " The original CSS code for forms has been stored in"
	ewarn "	${INSTALLDIR}/res/forms.css.without-${P}"
	elog
}