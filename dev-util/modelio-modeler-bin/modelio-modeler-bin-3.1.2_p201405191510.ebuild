# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=3

inherit unpacker

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}" # full version from *.deb:/control.tar.gz:/control
MYVERBAS=$(echo "${MYVERMAJ}" | cut -d . -f 1-2)

DESCRIPTION="Modelio is first and foremost a modeling environment, supporting a wide range of UML/BPMN models and diagrams, and providing model assistance and consistency checking features."
HOMEPAGE="http://www.modeliosoft.com/en/download/dl-modelio.html"
SRC_URI_PREFIX="http://www.modeliosoft.com/en/component/docman/doc_download"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}/660-solution-modelio-${MYVERMAJ//./}-debian-32-bit.html -> modelio-modeler-${MYVERMAJ}-i386.deb )
	amd64?	( ${SRC_URI_PREFIX}/659-solution-modelio-${MYVERMAJ//./}-debian-64-bit.html -> modelio-modeler-${MYVERMAJ}-amd64.deb )"
SLOT="0"
RESTRICT="fetch"
KEYWORDS="x86 amd64"
DEPEND="net-libs/webkit-gtk:2" # for org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
RDEPEND=">=virtual/jre-1.5"

src_prepare() {
	# from *.deb:/control.tar.gz:/postinst
	local MODELIO_PATH="/usr/lib/modelio-by-modeliosoft${MYVERBAS}"
	local MODELIO_LNK="/usr/bin/modelio${MYVERBAS}"
	mkdir -p $(dirname "${WORKDIR}${MODELIO_LNK}")
	ln -s "${MODELIO_PATH}/modelio" "${WORKDIR}${MODELIO_LNK}"
	# remove bundled Java, uninstaller, updater, and Windows binaries
	rm -rf "${WORKDIR}${MODELIO_PATH}/jre" "${WORKDIR}${MODELIO_PATH}/lib"
	# remove executable bit
	chmod a-x "${WORKDIR}${MODELIO_PATH}/mdastore"/* "${WORKDIR}${MODELIO_PATH}/templates"/*
	find "${WORKDIR}/usr/share" -type f -print0 | xargs -0 chmod a-x
}

src_install() {
	mv "${WORKDIR}/usr" "${D}" || die "Unable to move file for instalation!"
}