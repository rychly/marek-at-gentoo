# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

ECLMIN="20070927"
YERVER="2007"
MAJVER="${PV%_*}"
MINVER="${PV#*_p}"

DESCRIPTION="EclipseUML ${YERVER} Free Edition release for Eclipse 3.3 Java JEE Modelers."
HOMEPAGE="http://www.eclipsedownload.com/download_free_JEE_eclipse_3.3.html"
SRC_URI="http://www.download-omondo.com/eclipseUML_E${MAJVER//./}_${YERVER}_freeEdition_JEE_${MAJVER}.v${MINVER}.zip"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~x86 ~amd64"
DEPEND=">=dev-util/eclipse-jee-bin-${ECLMIN}"
RDEPEND=">=virtual/jre-1.5"

INSTALLDIR="/opt/eclipse-jee-bin"

src_unpack() {
	unpack ${A}
	# remove colisions with eclipse-jee-bin
	echo "
features/org.eclipse.emf
features/org.eclipse.emf.codegen
features/org.eclipse.emf.codegen.ecore
features/org.eclipse.emf.codegen.ecore.ui
features/org.eclipse.emf.codegen.ui
features/org.eclipse.emf.common
features/org.eclipse.emf.common.ui
features/org.eclipse.emf.converter
features/org.eclipse.emf.ecore
features/org.eclipse.emf.ecore.edit
features/org.eclipse.emf.ecore.editor
features/org.eclipse.emf.ecore.sdo
features/org.eclipse.emf.edit
features/org.eclipse.emf.edit.ui
features/org.eclipse.emf.mapping
features/org.eclipse.emf.mapping.ecore
features/org.eclipse.emf.mapping.ecore.editor
features/org.eclipse.emf.mapping.ui
features/org.eclipse.gef
features/org.eclipse.xsd
features/org.eclipse.xsd.edit
plugins/org.eclipse.draw2d
plugins/org.eclipse.emf
plugins/org.eclipse.emf.ant
plugins/org.eclipse.emf.codegen
plugins/org.eclipse.emf.codegen.ecore
plugins/org.eclipse.emf.codegen.ecore.ui
plugins/org.eclipse.emf.codegen.ui
plugins/org.eclipse.emf.common
plugins/org.eclipse.emf.commonj.sdo
plugins/org.eclipse.emf.common.ui
plugins/org.eclipse.emf.converter
plugins/org.eclipse.emf.ecore
plugins/org.eclipse.emf.ecore.edit
plugins/org.eclipse.emf.ecore.editor
plugins/org.eclipse.emf.ecore.change
plugins/org.eclipse.emf.ecore.change.edit
plugins/org.eclipse.emf.ecore.sdo
plugins/org.eclipse.emf.ecore.xmi
plugins/org.eclipse.emf.edit
plugins/org.eclipse.emf.edit.ui
plugins/org.eclipse.emf.exporter
plugins/org.eclipse.emf.importer
plugins/org.eclipse.emf.importer.ecore
plugins/org.eclipse.emf.importer.java
plugins/org.eclipse.emf.importer.rose
plugins/org.eclipse.emf.mapping
plugins/org.eclipse.emf.mapping.ecore
plugins/org.eclipse.emf.mapping.ecore.editor
plugins/org.eclipse.emf.mapping.ecore2ecore
plugins/org.eclipse.emf.mapping.ecore2ecore.editor
plugins/org.eclipse.emf.mapping.ecore2xml
plugins/org.eclipse.emf.mapping.ecore2xml.ui
plugins/org.eclipse.emf.mapping.ui
plugins/org.eclipse.gef
plugins/org.eclipse.xsd
plugins/org.eclipse.xsd.edit
" \
	| while read I; do
		[ -n "$I" ] && rm -rf "${WORKDIR}"/${I}_*
	done
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
