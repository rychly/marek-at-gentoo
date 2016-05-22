# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# adopted from http://data.gpo.zugaina.org/dmol/dev-db/hsqldb/hsqldb-2.2.8.ebuild

EAPI="4"
JAVA_PKG_IUSE="doc source test"

inherit user java-pkg-2 java-ant-2

DESCRIPTION="The leading SQL relational database engine written in Java."
HOMEPAGE="http://hsqldb.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}_2_2/${P}.zip"
LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="java-virtuals/servlet-api:3.0"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	test? ( dev-java/ant-junit
		dev-java/ant-core
		=dev-java/junit-3.8* )
	${COMMON_DEP}"

S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="servlet-api-3.0"
EANT_BUILD_TARGET="hsqldb sqltool hsqldbutil" #+hsqljdbc  ?
EANT_BUILD_XML="build/build.xml"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} available"
JAVA_PKG_BSFIX_NAME="build.xml test.xml"
#tests can't be compiled with ecj
JAVA_PKG_FORCE_COMPILER="javac"

HSQLDB_HOME="/var/lib/hsqldb-${SLOT}"

pkg_setup() {
	enewgroup hsqldb
	enewuser hsqldb -1 /bin/sh /dev/null hsqldb
	java-pkg-2_pkg_setup
}

java_prepare() {
	find \( -name '*.jar' -o -name '*.zip' \) -exec rm -v {} + || die
	# don't enable java7-only codepaths, currently there aren't any anyway.
	sed -i -e '/available classname="java.sql.PseudoColumnUsage/d' build/build.xml || die

	# doc-src doesn't exist; upstream make dist bug.
	mv doc doc-src || die

	mkdir conf

	sed -e "s/^server.database.0=.*$/server.database.0=file:${HSQLDB_HOME//\//\\/}\/db0/g" \
		sample/server.properties > conf/server.properties || die
	cp "${FILESDIR}/hsqldb-${SLOT}.conf" "conf/hsqldb-${SLOT}"
	cp conf/server.properties conf/webserver.properties
	sed -e '/^$/{N; /# Each server.database.X/ i\
\
#This is the server port for hsqldb Web Server\
server.port=8080\

}' conf/server.properties > conf/webserver.properties || die
	sed -e '/^$/{N; /# Template for a urlid for an Oracle database/ i\
# This is for a hsqldb Web Server running with default settings on your local\
# computer (and for which you have not changed the password for "SA").\
# Please note, that port setting should be the same as in webserver.properties\
urlid localhost-web-sa\
url jdbc:hsqldb:http://localhost:8080/\
username SA\
password\
\

}' sample/sqltool.rc > conf/sqltool.rc || die
}

EANT_TEST_GENTOO_CLASSPATH="servlet-api-3.0,junit" #,ant-core"
EANT_TEST_TARGET="hsqldbtest" #preprocessor"
EANT_TEST_EXTRA_ARGS="-D_junit_available=true"

src_test() {
	java-pkg-2_src_test
	# test-src missing from archieve, upstream make dist bug.
	#EANT_GENTOO_CLASSPATH="junit,ant-core" \
	#	eant -f "${EANT_BUILD_XML}" preprocessor
	#EANT_GENTOO_CLASSPATH="junit,ant-core" \
	#	ANT_OPTS="-Xmx1536m -XX:PermSize=1200m -Djunit.available=true" \
	#	ANT_TASKS="ant-junit" \
	#	eant -f build/test.xml make.test.suite run.test.suite

	local classpath=".:lib/hsqldb.jar:lib/hsqldbtest.jar"
	classpath+=":$(java-pkg_getjars --build-only junit)" || die
	java -cp ${classpath} org.hsqldb.test.TestUtil || die
}

src_install() {
	java-pkg_dojar lib/{hsqldb,hsqldbutil,sqltool}.jar

	if use doc; then
		java-pkg_dojavadoc doc-src/apidocs
		dodoc doc-src/*.txt
	fi
	use source && java-pkg_dosrc src/org

	# Servers
	java-pkg_dolauncher ${PN}-server-${SLOT} \
		--main org.hsqldb.server.Server
	java-pkg_dolauncher ${PN}-webserver-${SLOT} \
		--main org.hsqldb.server.WebServer

	# Tools
	java-pkg_dolauncher ${PN}-manager-${SLOT} \
		--main org.hsqldb.util.DatabaseManagerSwing
	java-pkg_dolauncher ${PN}-sqltool-${SLOT} \
		--main org.hsqldb.cmdline.SqlTool

	# Put init, configuration and authorization files in /etc
	doinitd "${FILESDIR}/hsqldb-${SLOT}"
	doconfd "conf/hsqldb-${SLOT}"

	dodir "/etc/hsqldb-${SLOT}"
	insinto "/etc/hsqldb-${SLOT}"
	# Change the ownership of server.properties and sqltool.rc
	# files to hsqldb:hsqldb. (resolves Bug #111963)
	insopts -m0600 -o hsqldb -g hsqldb
	diropts -m0700 -o hsqldb -g hsqldb

	doins "${S}/conf/server.properties"
	doins "${S}/conf/webserver.properties"
	doins "${S}/conf/sqltool.rc"

	dodir "${HSQLDB_HOME}"

	dodir /var/log
	touch "${D}"var/log/hsqldb-${SLOT}.log
	fowners hsqldb:hsqldb /var/log/hsqldb-${SLOT}.log

	# Create symlink to server.properties
	# (required by the hqldb init script)
	insinto "${HSQLDB_HOME}"
	for cfg in "server.properties" "webserver.properties" "sqltool.rc"; do
		dosym "/etc/hsqldb-${SLOT}/${cfg}" "${HSQLDB_HOME}/${cfg}"
	done

}

pkg_postinst() {
	elog "hsqldb-${SLOT} server will start with default database"
	elog "and default credentials (SA/(empty password))."
	elog "Please change /etc/hsqldb-${SLOT}/server.properties"
	elog "/etc/hsqldb-${SLOT}/sqltool.rc if the default behaviour"
	elog "is not desired."
}