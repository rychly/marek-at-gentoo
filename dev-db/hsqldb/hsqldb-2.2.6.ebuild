# $Id$

EAPI=1
JAVA_PKG_IUSE="doc source test"
inherit eutils versionator java-pkg-2 java-ant-2

DESCRIPTION="The leading SQL relational database engine written in Java."
HOMEPAGE="http://hsqldb.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x64-solaris"
IUSE=""
RESTRICT="mirror"

CDEPEND="java-virtuals/servlet-api:2.3"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/junit:0 )
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${P}/${PN}"

HSQLDB_JAR=/usr/share/hsqldb/lib/hsqldb.jar

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v lib/*.jar || die
	java-pkg_jar-from --virtual --into lib servlet-api-2.3

	java-pkg_filter-compiler jikes

	eant -q -f "${EANT_BUILD_XML}" clean-all > /dev/null

	# pathlist file for CodeSwitcher
	ln -s 'build/jdkcodeswitch.list' "${S}"
}

# EANT_BUILD_XML used also in src_unpack
EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="hsqldb hsqljdbc sqltool hsqldbutil"
EANT_DOC_TARGET="javadocdev"

src_test() {
	java-pkg_jar-from --into lib junit
	eant -f ${EANT_BUILD_XML} jartest
	cd testrun/hsqldb || die
	./runTest.sh TestSelf || die "TestSelf hsqldb tests failed"
	# TODO. These fail. Investigate why.
	#cd "${S}/testrun/sqltool" || die
	#CLASSPATH="${S}/lib/hsqldb.jar" ./runtests.bash || die "sqltool test failed"
}

src_install() {
	java-pkg_dojar lib/hsql*.jar lib/sqltool.jar

	if use doc; then
		dodoc doc/*.txt
		dohtml -r doc/zaurus
		dohtml -r doc/src
	fi
	use source && java-pkg_dosrc src/*
}
