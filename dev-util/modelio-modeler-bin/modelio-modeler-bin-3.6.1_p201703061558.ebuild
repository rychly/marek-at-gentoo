# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit versionator unpacker

# full version (ebuild patch version) from *.deb:/control.tar.gz:/control
MYVERBAS="$(get_version_component_range 1-2)"
MYVERMAJ="$(get_version_component_range 1-3)"

DESCRIPTION="A modeling environment supporting a wide range of UML/BPMN models and diagrams"
HOMEPAGE="https://www.modeliosoft.com/en/modules/modelio-modeler.html"
DOWNLOAD_PAGE="https://www.modeliosoft.com/en/download/download-products.html"
SRC_URI_PREFIX="https://www.modeliosoft.com/en/downloads/modeliosoft-products"
SRC_URI="\
	x86?	( ${SRC_URI_PREFIX}/modelio-${MYVERBAS//./-}-x/22-modelio-${MYVERMAJ//./-}-debian-32-bit/file.html -> modelio-${MYVERMAJ}-modeler-i386.deb )
	amd64?	( ${SRC_URI_PREFIX}/modelio-${MYVERBAS//./-}-x/22-modelio-${MYVERMAJ//./-}-debian-64-bit/file.html -> modelio-${MYVERMAJ}-modeler-amd64.deb )"

LICENSE="modeliosoft"
SLOT="$(get_version_component_range 1-2)"
IUSE="-systemjre"
RESTRICT="fetch"
KEYWORDS="x86 amd64"
RDEPEND="systemjre? ( >=virtual/jre-1.8 )"

# GTK+2 for org.eclipse.swt.SWTError: No more handles [Unknown Mozilla path (MOZILLA_FIVE_HOME not set)]
# and set env variable SWT_GTK3=0 in ${MODELIO_PATH}/modelio.sh to use GTK+2 instead of GTK+3
# for org.eclipse.e4.core.di.InjectionException: org.eclipse.swt.SWTError: No more handles [Browser style SWT.MOZILLA and Java system property org.eclipse.swt.browser.DefaultType=mozilla are not supported with GTK 3 as XULRunner is not ported for GTK 3 yet] org.eclipse.swt.SWTError: No more handles [Browser style SWT.MOZILLA and Java system property org.eclipse.swt.browser.DefaultType=mozilla are not supported with GTK 3 as XULRunner is not ported for GTK 3 yet]
# FIXED: 1.9.2.x XULRunner releases provide require API (not available in later versions of XULRunner)
RDEPEND="${RDEPEND}
	net-libs/xulrunner-bin:1.9.2"

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
