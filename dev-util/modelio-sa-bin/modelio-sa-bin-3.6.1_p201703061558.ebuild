# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit unpacker

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}" # full version from *.deb:/control.tar.gz:/control
MYVERBAS="${MYVERMAJ%.*}"

DESCRIPTION="A set of dedicated features for system, software and embedded software architects (SysML, UPDM, NAF, DoDAF, MODAF, ...)"
HOMEPAGE="https://www.modeliosoft.com/en/products/modelio-sa-system-architects.html"
DOWNLOAD_PAGE="https://www.modeliosoft.com/en/download/download-products.html#modelio_sa"
SRC_URI="https://www.modeliosoft.com/en/downloads/modeliosoft-products/modelio-${MYVERBAS//./-}-x/24-modelio-sa-${MYVERMAJ//./-}-debian/file.html -> modelio-${MYVERMAJ}-sa.deb"
LICENSE="modeliosoft"
SLOT="0"
RESTRICT="fetch"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND="=dev-util/modelio-modeler-bin-${MYVERMAJ}_p*"

pkg_nofetch() {
	einfo
	einfo " Because of license terms and file name conventions, please:"
	einfo
	einfo " 1. Visit ${DOWNLOAD_PAGE}"
	einfo "    (you may need to create an account on Modeliosoft's site)"
	einfo " 2. Download the appropriate file:"
	einfo "    ${SRC_URI}"
	einfo " 3. Place the files in ${DISTDIR}"
	einfo " 4. Resume the installation."
	einfo
}

src_prepare() {
	# from *.deb:/control.tar.gz:/postinst
	local MODELIO_PATH="/usr/lib/modelio-by-modeliosoft${MYVERBAS}"
	local MODELIO_CACHE_TAR="/usr/share/modelio-by-modeliosoft-solutions${MYVERBAS}/modelio-system-architect-product${MYVERBAS}.tar"
	mkdir -p "${WORKDIR}${MODELIO_PATH}"
	tar -x --no-same-owner -f "${WORKDIR}${MODELIO_CACHE_TAR}" -C "${WORKDIR}${MODELIO_PATH}" \
		&& rm "${WORKDIR}${MODELIO_CACHE_TAR}"
	chmod 644 "${WORKDIR}${MODELIO_PATH}/mdastore"/*.jmdac "${WORKDIR}${MODELIO_PATH}/templates"/*.template
}

src_install() {
	mv "${WORKDIR}/usr" "${D}" || die "Unable to move file for instalation!"
}
