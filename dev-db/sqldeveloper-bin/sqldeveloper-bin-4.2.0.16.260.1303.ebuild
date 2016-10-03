# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MYSQLCONVER=5.1.36

DESCRIPTION="Oracle SQL Developer is a free graphical tool for database development."
HOMEPAGE="http://www.oracle.com/technology/products/database/sql_developer/"
DOWNLOAD_PAGE="http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/"
SRC_URI="http://download.oracle.com/otn/java/sqldeveloper/${PN//-bin/}-${PV}-no-jre.zip
	mysql? ( mirror://mysql/Downloads/Connector-J/mysql-connector-java-${MYSQLCONVER}.tar.gz )"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="mysql"
LICENSE="oracle-jdbc"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.8"
RESTRICT="fetch"

S="${WORKDIR}/${PN//-bin/}"
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
	# mysql
	if use mysql; then
		mv "${WORKDIR}/mysql-connector-java-${MYSQLCONVER}/mysql-connector-java-${MYSQLCONVER}-bin.jar" "${S}/jdbc/lib/" || die "Cannot install MySQL JDBC driver"
		echo "AddJavaLibFile ../../jdbc/lib/mysql-connector-java-${MYSQLCONVER}-bin.jar" >>"${S}/sqldeveloper/bin/sqldeveloper.conf"
	fi
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}"
	make_desktop_entry "${INSTALLDIR}/sqldeveloper.sh" "Oracle SQL Developer" "${INSTALLDIR}/icon.png" "Database;Office;Development;KDE;Qt"
	# environment variables
	dodir "/etc/env.d"
	cat > "${D}/etc/env.d/50${PN}" <<END
PATH=${INSTALLDIR}/sqldeveloper/bin
ROOTPATH=${INSTALLDIR}
END
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${INSTALLDIR}\"" > "${D}/etc/revdep-rebuild/50${PN}"
}
