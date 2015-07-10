# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=3

inherit unpacker

MYPNMAIN="${PN%%-bin}"
MYVERMAJ="${PV%%_p*}"
MYVERMIN="${PV##*_p}" # full version from *.deb:/control.tar.gz:/control
MYVERBAS=$(echo "${MYVERMAJ}" | cut -d . -f 1-2)

DESCRIPTION="Modelio is first and foremost a modeling environment, supporting a wide range of UML/BPMN models and diagrams, and providing model assistance and consistency checking features."
HOMEPAGE="https://www.modeliosoft.com/en/modules/modelio-modeler.html"
DOWNLOAD_PAGE="http://www.modeliosoft.com/en/download/dl-modelio.html"
SRC_URI_PREFIX="http://www.modeliosoft.com/en/component/docman/doc_download"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}/944-solution-modelio-${MYVERMAJ//./}-debian-32-bit.html -> modelio-modeler-${MYVERMAJ}-i386.deb )
	amd64?	( ${SRC_URI_PREFIX}/945-solution-modelio-${MYVERMAJ//./}-debian-64-bit.html -> modelio-modeler-${MYVERMAJ}-amd64.deb )"
SLOT="0"
IUSE="-systemjre"
RESTRICT="fetch"
KEYWORDS="x86 amd64"
RDEPEND="systemjre? ( >=virtual/jre-1.8 )"

# GTK+2 for org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
# and set env variable SWT_GTK3=0 in ${MODELIO_PATH}/modelio.sh to use GTK+2 instead of GTK+3
# for org.eclipse.e4.core.di.InjectionException: org.eclipse.swt.SWTError: No more handles [Browser style SWT.MOZILLA and Java system property org.eclipse.swt.browser.DefaultType=mozilla are not supported with GTK 3 as XULRunner is not ported for GTK 3 yet] org.eclipse.swt.SWTError: No more handles [Browser style SWT.MOZILLA and Java system property org.eclipse.swt.browser.DefaultType=mozilla are not supported with GTK 3 as XULRunner is not ported for GTK 3 yet]
DEPEND="net-libs/webkit-gtk:2"

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
	local MODELIO_LNK="/usr/bin/modelio${MYVERBAS}"
	mkdir -p $(dirname "${WORKDIR}${MODELIO_LNK}")
	ln -s "${MODELIO_PATH}/modelio.sh" "${WORKDIR}${MODELIO_LNK}"
	# remove bundled Java
	if use systemjre; then
		rm -rf "${WORKDIR}${MODELIO_PATH}/jre" "${WORKDIR}${MODELIO_PATH}/lib"
		ln -s /etc/java-config-2/current-system-vm/jre "${WORKDIR}${MODELIO_PATH}/jre"
	fi
	# remove executable bit
	chmod a-x "${WORKDIR}${MODELIO_PATH}/modules"/* "${WORKDIR}${MODELIO_PATH}/templates"/*
	find "${WORKDIR}/usr/share" -type f -print0 | xargs -0 chmod a-x
}

src_install() {
	mv "${WORKDIR}/usr" "${D}" || die "Unable to move file for instalation!"
}
