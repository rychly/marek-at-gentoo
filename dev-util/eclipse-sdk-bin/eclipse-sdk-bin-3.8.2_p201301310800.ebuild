# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MIRROR="http://eclipse.mirror.dkm.cz/pub/eclipse"

DESCRIPTION="Eclipse Tools Platform"
HOMEPAGE="http://archive.eclipse.org/eclipse/downloads/"
SRC_URI="x86? ( ${MIRROR}/eclipse/downloads/drops/R-${PV/_p/-}/eclipse-SDK-${PV%_p*}-linux-gtk.tar.gz )
	amd64? ( ${MIRROR}/eclipse/downloads/drops/R-${PV/_p/-}/eclipse-SDK-${PV%_p*}-linux-gtk-x86_64.tar.gz )"
SLOT="${PV%.*}"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/eclipse"
INSTALLDIR="/opt/${PN}-v${SLOT}"

src_unpack() {
	unpack ${A}
	rm -rf "${S}/about_files"
	mv "${S}"/*.html "${S}/readme"
	mv "${S}/readme" "${S}/.readme"
	cp "${S}/plugins"/org.eclipse.sdk_*/eclipse48.png "${S}"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
	dodoc "${S}/.readme"/*
	make_desktop_entry "${INSTALLDIR}/eclipse" "Eclipse Tools Platform ${SLOT}" "${INSTALLDIR}/eclipse48.png" "Development;IDE"
	# environment variables
	dodir "/etc/env.d"
	cat > "${D}/etc/env.d/50${PN}-${SLOT}" <<END
PATH=${INSTALLDIR}
ROOTPATH=${INSTALLDIR}
END
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${INSTALLDIR}\"" > "${D}/etc/revdep-rebuild/50${PN}-${SLOT}"
}

pkg_postinst() {
	# info about additional packages
	einfo
	einfo "To install EMF and GMF:"
	einfo "* menu Help > Install New Software,"
	einfo "  link 'Available Software Sites',"
	einfo "  add new site with name 'Juno' (for Eclipse ${SLOT}) and location 'http://download.eclipse.org/releases/juno/'"
	einfo "* menu Help > Install New Software,"
	einfo "  work with 'Juno',"
	einfo "  select and install/next"
	einfo "  + Ecore Tools"
	einfo "  + Ecore Tools SDK"
	einfo "  + EMF - Eclipse Modeling Framework Runtime and Tools"
	einfo "  + EMF SDK - Eclipse Modeling Framework SDK"
	einfo "  + Graphical Modeling Framework Runtime"
	einfo "  + Graphical Modeling Framework SDK"
	einfo
	einfo "To install Xtext and SADL:"
	einfo "* menu Help > Install New Software,"
	einfo "  link 'Available Software Sites',"
	einfo "  add new sites"
	einfo "  + with name 'Xtext' and location 'http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/'"
	einfo "  + with name 'SADL' and location 'http://sadl.sourceforge.net/update/'"
	einfo "* menu Help > Install New Software,"
	einfo "  work with 'SADL',"
	einfo "  select and install/next"
	einfo "  + Semantic Application Design Language Version 2"
	einfo
}
