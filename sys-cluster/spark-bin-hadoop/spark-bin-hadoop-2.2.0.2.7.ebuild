# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

PV_SPARK="${PV%.*.*}"
PV_HADOOP="${PV#*.*.*.}"

DESCRIPTION="Apache Spark is a fast and general engine for large-scale data processing (binary pre-built for Hadoop)."
SRC_URI="mirror://apache/spark/spark-${PV_SPARK}/spark-${PV_SPARK}-bin-hadoop${PV_HADOOP}.tgz"
HOMEPAGE="https://spark.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="!sys-cluster/spark"
RDEPEND="virtual/jre:1.8"

S="${WORKDIR}/spark-${PV_SPARK}-bin-hadoop${PV_HADOOP}"
INSTALL_DIR="/opt/spark-bin-hadoop"

src_prepare() {
	find . -name \*.cmd -delete
}

src_install() {
	dodir "${INSTALL_DIR}"
	mv ${S}/* "${D}${INSTALL_DIR}/"
	echo -e "PATH=${INSTALL_DIR}/bin\nROOTPATH=${INSTALL_DIR}" > "${T}/25${PN}" || die
	doenvd "${T}/25${PN}"
}
