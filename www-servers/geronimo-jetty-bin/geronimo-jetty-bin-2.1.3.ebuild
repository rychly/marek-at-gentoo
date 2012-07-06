# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

DESCRIPTION="Geronimo Java EE application server, which has passed the SUN's JEE5 Certification Test Suite, with Web container Jetty."

SRC_URI="mirror://apache/dist/geronimo/${PV}/geronimo-jetty6-javaee5-${PV}-bin.tar.gz"
HOMEPAGE="http://geronimo.apache.org/"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""
RESTRICT="mirror"

DEPEND="!www-servers/geronimo-tomcat"

RDEPEND="=virtual/jdk-1.5*"

S="${WORKDIR}/geronimo-jetty6-javaee5-${PV}"

pkg_setup() {
	enewgroup geronimo
	enewuser geronimo -1 -1 /dev/null geronimo
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	dodir "/opt/${PN}"
	mv "${S}"/* "${D}/opt/${PN}/" || die "Cannot install"
	chown -R geronimo:geronimo "${D}/opt/${PN}"
	chmod -R og-rwx "${D}/opt/${PN}"
	rm "${D}/opt/${PN}/bin"/*.bat
	chmod -x "${D}/opt/${PN}/bin"/*.jar
	chmod +x "${D}/opt/${PN}/bin"/*.sh
}