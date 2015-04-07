# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=3

inherit unpacker

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}" # full version from *.deb:/control.tar.gz:/control
MYVERBAS=$(echo "${MYVERMAJ}" | cut -d . -f 1-2)

DESCRIPTION="The Modeliosoft Ultimate Solution provides the entire set of features and modules for the most advanced users of Modelio who want to get the very most out of their models."
HOMEPAGE="http://www.modeliosoft.com/en/download/ultimate-solution.html"
SRC_URI="http://www.modeliosoft.com/en/component/docman/doc_download/942-solution-ultimate-solution-${MYVERMAJ//./}-debian.html -> modelio-ultimate-solution-${MYVERMAJ}-all.deb"
SLOT="0"
RESTRICT="fetch"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND="=dev-util/modelio-modeler-bin-${MYVERMAJ}_p*"

src_prepare() {
	# from *.deb:/control.tar.gz:/postinst
	local MODELIO_PATH="/usr/lib/modelio-by-modeliosoft${MYVERBAS}"
	local MODELIO_CACHE_TAR="/var/cache/modelio-by-modeliosoft${MYVERBAS}/${MYPNMAIN}${MYVERBAS}.tar"
	mkdir -p "${WORKDIR}${MODELIO_PATH}"
	tar -x --no-same-owner -f "${WORKDIR}${MODELIO_CACHE_TAR}" -C "${WORKDIR}${MODELIO_PATH}" \
		&& rm "${WORKDIR}${MODELIO_CACHE_TAR}"
	chmod 644 "${WORKDIR}${MODELIO_PATH}/mdastore"/*.jmdac "${WORKDIR}${MODELIO_PATH}/templates"/*.template
}

src_install() {
	mv "${WORKDIR}/usr" "${D}" || die "Unable to move file for instalation!"
}
