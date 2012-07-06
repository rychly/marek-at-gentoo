# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit eutils

NB_MAJV=${PV%%_*}
NB_DATE=${PV##*_p}

DESCRIPTION="The NetBeans IDE is a free, open-source Integrated Development Environment for software developers."
HOMEPAGE="http://www.netbeans.org/products/ide/"
SRC_URI="http://download.netbeans.org/netbeans/${NB_MAJV}/final/zip/netbeans-${NB_MAJV}-${NB_DATE}-ml.zip"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="x86 amd64"
IUSE="tomcat"
PDEPEND=">=virtual/jre-1.6
	tomcat? ( >=virtual/jdk-1.6 =www-servers/tomcat-6.0* )"

S="${WORKDIR}/netbeans"
INSTALLDIR="/opt/${PN}"
TOMCATENDORSED60="/usr/share/tomcat-6/endorsed" # ${/etc/conf.d/tomcat-6:CATALINA_HOME}/endorsed

src_unpack() {
	unpack ${A}
	# remove Windows and MacOS files
	find "${S}" -regex '.*\.\(exe\|cmd\|bat\|dll\|dylib\)$' | xargs rm --verbose
	# distr-docs
	mkdir "${S}/.docs"
	mv "${S}"/CREDITS* "${S}"/DISTRIBUTION* "${S}"/LEGALNOTICE* "${S}"/LICENSE* "${S}"/README* "${S}"/THIRDPARTYLICENSE* "${S}/.docs"
	rm "${S}/netbeans.css"
	# set JDK home directory
	echo 'netbeans_jdkhome="/etc/java-config-2/current-system-vm/"' >> "${S}/etc/netbeans.conf"
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}" || die "Cannot install files from work-dir."
	dodoc "${S}/.docs"/*
	make_desktop_entry "${INSTALLDIR}/bin/netbeans" "NetBeans IDE" "${INSTALLDIR}/nb/netbeans.png" "Development;IDE"
	# environment variables
	dodir "/etc/env.d"
	cat > "${D}/etc/env.d/50${PN}" <<END
PATH=${INSTALLDIR}/bin
ROOTPATH=${INSTALLDIR}
END
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${INSTALLDIR}\"" > "${D}/etc/revdep-rebuild/50${PN}"
	# move JAX-WS 2.1 APIs to Tomcat's endorsed directory (-Djava.endorsed.dirs=/usr/share/tomcat-6/endorsed)
	# http://wiki.netbeans.info/wiki/view/FaqEndorsedDirTomcat
	if use tomcat; then
		dodir "${TOMCATENDORSED60}"
		ln "${D}/${INSTALLDIR}/java1/modules/ext/jaxws21/api"/*.jar "${D}/${TOMCATENDORSED60}/" \
		|| die "Cannot move JAX-WS 2.1 APIs to Tomcat's endorsed directory."
	fi
}

pkg_postinst() {
	if use tomcat; then
		elog
		elog  " We moved JAX-WS 2.1 APIs to Tomcat's endorsed directory"
		ewarn "  ${TOMCATENDORSED60}"
		elog  " Please finish this operation in /etc/conf.d/tomcat-6 by checking"
		ewarn "  CATALINA_HOME=${TOMCATENDORSED60%%endorsed}"
		elog  " and by adding of the following java option and enabling it"
		ewarn "  JAVA_OPTS=\"-Djava.endorsed.dirs=${TOMCATENDORSED60}\""
		elog  " See http://wiki.netbeans.info/wiki/view/FaqEndorsedDirTomcat for more information."
		elog
	fi
}
