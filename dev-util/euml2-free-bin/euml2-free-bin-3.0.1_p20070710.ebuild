# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

ECLMIN="20070927"
MAJVER="${PV%_*}"
MINVER="${PV#*_p}"

DESCRIPTION="eUML2 Studio is a powerful set of tools developped from scratch for Eclipse"
HOMEPAGE="http://www.soyatec.com/euml2/features/"
SRC_URI="http://www.soyatec.cn/releases/eUML2-Free-Edition-${MAJVER}.${MINVER}+dependencies_for_eclipse3.3.zip"
LICENSE="euml2-studio-commercial-license"
SLOT="0"
IUSE="nouml2"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
DEPEND=">=dev-util/eclipse-jee-bin-${ECLMIN}"
RDEPEND=">=virtual/jre-1.5"

INSTALLDIR="/opt/eclipse-jee-bin"

src_unpack() {
	unpack ${A}
	# remove colisions with eclipse-jee-bin
	rm -rf "${WORKDIR}/plugins"/org.eclipse.draw2d_*
	# remove colisions with eclipse-uml-bin
	if use nouml2; then
		rm -rf "${WORKDIR}/plugins"/org.eclipse.uml2.codegen.ecore.ui_* "${WORKDIR}/plugins"/org.eclipse.uml2_* \
		"${WORKDIR}/plugins"/org.eclipse.uml2.uml.editor_* "${WORKDIR}/plugins"/org.eclipse.uml2.uml.resources_* \
		"${WORKDIR}/plugins"/org.eclipse.uml2.uml.ecore.exporter_* "${WORKDIR}/plugins"/org.eclipse.uml2.common.edit_* \
		"${WORKDIR}/plugins"/org.eclipse.uml2.uml.ecore.importer_*
	else
		einfo "In case of file collisions with ebuild dev-util/eclipse-uml-bin enable use flag 'nouml2'."
	fi
}

src_install() {
	plugins=`ls "${WORKDIR}/plugins" | egrep -o '[^_]*' | sort | uniq`
	dodir "${INSTALLDIR}"
	mv "${WORKDIR}/features" "${WORKDIR}/plugins" "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
}

pkg_postinst() {
	einfo ""
	einfo "This ebuild has added some plugins into Eclipse IDE for Java EE Developers instalation:"
	ewarn "    `echo ${plugins} | sed 's/ /, /g'`"
	einfo ""
	einfo "We especially alert to the plugins:"
	ewarn "    `echo ${plugins} | tr ' ' '\n' | grep 'org\.eclipse\.' | tr '\n' ' ' | sed 's/ /, /g'`"
	einfo "which can be also installed via Eclipse Update Manager."
	einfo ""
}
