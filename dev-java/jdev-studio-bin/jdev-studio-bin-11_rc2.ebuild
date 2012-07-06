# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Oracle JDeveloper Studio Edition"
HOMEPAGE="http://www.oracle.com/technology/products/jdev/"
DOWNLOAD_PAGE="http://www.oracle.com/technology/software/products/jdev/htdocs/soft11tp.html"
SRC_URI="http://download.oracle.com/otn/java/jdeveloper/11/jdevstudiobase1111.zip"
KEYWORDS="~x86 ~amd64"
LICENSE="oracle-jdbc"
SLOT="11"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"
RESTRICT="fetch"

S="${WORKDIR}"
INSTALLDIR="/opt/${PN}"

pkg_nofetch() {
	einfo
	einfo " Because of license terms and file name conventions, please:"
	einfo
	einfo " 1. Visit ${DOWNLOAD_PAGE}"
	einfo "    (you may need to create an account on Oracle's site)"
	einfo " 2. Download the appropriate file:"
	einfo "    ${SRC_URI}"
	einfo " 3. Place the files in ${DISTDIR}"
	einfo " 4. Resume the installation."
	einfo
}
        
src_unpack() {
	unpack ${A}
	# remove Windows files
	find "${S}" -regex '.*\.\(exe\|cmd\|bat\)$' | xargs rm --verbose
	egrep -R "^#!.*/bin/" "${S}" | cut -d ":" -f 1 | xargs chmod --verbose 755
	# create desktop files
	sed 's/^\(PRODUCT_NAME_.*=\)\(.*\)$/\1"\2"/g' "${S}/jdev/bin/addjdevtodesktop" >"${S}/jdev/bin/addjdevtodesktop.new" \
	&& cat "${S}/jdev/bin/addjdevtodesktop.new" >"${S}/jdev/bin/addjdevtodesktop" && rm "${S}/jdev/bin/addjdevtodesktop.new"
	mkdir "${S}/KDesktop" "${S}/.gnome-desktop"
	HOME="${S}" "${S}/jdev/bin/addjdevtodesktop" && rm "${S}/jdev/bin/addjdevtodesktop"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}"
                
        dodir /etc/env.d
        echo -e "PATH=${INSTALLDIR}/jdev/bin\nROOTPATH=${INSTALLDIR}" > "${D}"/etc/env.d/10jdev
                
        insinto /usr/share/applications
        doins "${S}"/.gnome-desktop/*.desktop
}
