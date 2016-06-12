# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2 user

DESCRIPTION="Java EE application server with Web container Jetty"

SRC_URI="mirror://apache/dist/geronimo/${PV}/geronimo-jetty6-javaee5-${PV}-bin.tar.gz"
HOMEPAGE="http://geronimo.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!www-servers/geronimo-tomcat"

RDEPEND="virtual/jdk"

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
