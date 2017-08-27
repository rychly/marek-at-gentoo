# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# based on https://data.gpo.zugaina.org/fw-overlay/dev-db/apache-cassandra-bin/apache-cassandra-bin-3.3.ebuild

EAPI=4

inherit eutils user systemd versionator

DESCRIPTION="Cassandra is a distributed (peer-to-peer) system for the management and storage of structured data."
HOMEPAGE="https://cassandra.apache.org/"
SRC_URI="mirror://apache/cassandra/${PV}/apache-cassandra-${PV}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

DEPEND="!dev-db/apache-cassandra"
RDEPEND="virtual/jre:1.8
	>=dev-lang/python-2.7
	systemd? ( sys-apps/systemd )"

S="${WORKDIR}/apache-cassandra-${PV}"
INSTALL_DIR="/opt/cassandra-${SLOT}"
VARLIB_DIR="/var/lib/cassandra-${SLOT}"

pkg_setup() {
	enewgroup cassandra
	enewuser cassandra -1 /bin/bash "${INSTALL_DIR}" cassandra
}

src_prepare() {
	cd "${S}"
	find . \( -name \*.bat -or -name \*.exe -or -name \*.ps1 \) -delete
	rm bin/stop-server

	sed \
		-e "s|/var/lib/cassandra|${VARLIB_DIR}|g" \
		-i conf/cassandra.yaml || die

	sed \
		-e "s|CASSANDRA_HOME=\".*\"|CASSANDRA_HOME=\"${INSTALL_DIR}\"|g" \
		-e "s|cassandra_storagedir=\"[^\"]*\"|cassandra_storagedir=\"${VARLIB_DIR}\"|g" \
		-i bin/cassandra.in.sh || die
}

src_install() {
	dodir "${INSTALL_DIR}"
	mv ${S}/* "${D}${INSTALL_DIR}/"

	keepdir "${VARLIB_DIR}"

	fowners -R cassandra:cassandra "${INSTALL_DIR}"
	fowners -R cassandra:cassandra "${VARLIB_DIR}"

	for I in "${D}${INSTALL_DIR}"/bin/*; do
		[[ -x "${I}" ]] && make_wrapper "${I##*/}-${SLOT}" "${INSTALL_DIR}/bin/${I##*/}"
	done

	if use systemd; then
		sed -e "s/{SLOT}/${SLOT}/g" -e "s/{PV}/${PV}/g" "${FILESDIR}/cassandra.service" > "${T}/cassandra-${SLOT}.service" || die
		systemd_dounit "${T}/cassandra-${SLOT}.service"
	else
		sed -e "s/{SLOT}/${SLOT}/g" -e "s/{PV}/${PV}/g" "${FILESDIR}/cassandra.initd" > "${T}/cassandra-${SLOT}.initd" || die
		newinitd "${T}/cassandra-${SLOT}.initd" "cassandra-${SLOT}"
	fi

	echo -e "CONFIG_PROTECT=${INSTALL_DIR}/conf\nROOTPATH=${INSTALL_DIR}" > "${T}/25cassandra-${SLOT}" || die
	#echo -e "PATH=${INSTALL_DIR}/bin\n" >> "${T}/25cassandra-${SLOT}" || die # skip as the executables are run via slotted wrappers
	doenvd "${T}/25cassandra-${SLOT}"
}

pkg_postinst() {
	elog "Cassandra's configuration is at ${INSTALL_DIR}/conf"
	elog "Cassandra works best when the commitlog directory and the data directory are on different disks"
	elog "The default configuration sets them to ${VARLIB_DIR}/{commitlog,data} respectively"
	elog "You may wish to change those to different mount points"
	ewarn "You should start/stop cassandra via '/etc/init.d/cassandra-${SLOT} start' or 'systemctl start cassandra-${SLOT}.service', as this will properly switch to the cassandra:cassandra user group"
	ewarn "Starting cassandra via its default 'cassandra' shell command, as root, may cause permission problems later on when started as the cassandra user"
}
