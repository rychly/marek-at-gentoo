# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator

PV_MAJ="$(get_version_component_range 1-3)"
PV_MIN="$(get_version_component_range 4)"
PV_PRE="${PV##*_pre}"
PV_DATETIME="${PV_PRE:0:4}-${PV_PRE:4:2}-${PV_PRE:6:2}-${PV_PRE:8:2}-${PV_PRE:10:2}-${PV_PRE:12:2}"
PV_DIR="${PV_PRE:0:4}/${PV_PRE:4:2}"

DESCRIPTION="Mozilla XULRunner application framework"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Archive/Mozilla/XULRunner/${PV_MAJ}"
SRC_PREFIX="https://ftp.mozilla.org/pub/xulrunner/nightly/${PV_DIR}/${PV_DATETIME}-mozilla-${PV_MAJ}/xulrunner-${PV_MAJ}.${PV_MIN}pre.en-US.linux"
SRC_URI="x86? ( ${SRC_PREFIX}-i686.tar.bz2 )
	amd64? ( ${SRC_PREFIX}-x86_64.tar.bz2 )"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="$(get_version_component_range 1-3)"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

QA_PRESTRIPPED="/opt/xulrunner/libnssdbm3.so
	/opt/xulrunner/libjavaxpcomglue.so
	/opt/xulrunner/libnssutil3.so
	/opt/xulrunner/libplds4.so
	/opt/xulrunner/xpcshell
	/opt/xulrunner/libsoftokn3.so
	/opt/xulrunner/xpt_dump
	/opt/xulrunner/xulrunner-stub
	/opt/xulrunner/libsqlite3.so
	/opt/xulrunner/xulrunner-bin
	/opt/xulrunner/components/libimgicon.so
	/opt/xulrunner/components/libdbusservice.so
	/opt/xulrunner/components/libmozgnome.so
	/opt/xulrunner/components/libnkgnomevfs.so
	/opt/xulrunner/libnssckbi.so
	/opt/xulrunner/libnss3.so
	/opt/xulrunner/mozilla-xremote-client
	/opt/xulrunner/libfreebl3.so
	/opt/xulrunner/updater
	/opt/xulrunner/libmozjs.so
	/opt/xulrunner/libxul.so
	/opt/xulrunner/crashreporter
	/opt/xulrunner/libssl3.so
	/opt/xulrunner/xpidl
	/opt/xulrunner/xpt_link
	/opt/xulrunner/libsmime3.so
	/opt/xulrunner/libnspr4.so
	/opt/xulrunner/plugin-container
	/opt/xulrunner/libplc4.so
	/opt/xulrunner/plugins/libnullplugin.so
	/opt/xulrunner/plugins/libunixprintplugin.so
	/opt/xulrunner/libxpcom.so"

S="${WORKDIR}/xulrunner"

src_install() {
	# main
	dodir /opt
	mv ${S} ${D}/opt || die "Cannot move the main directory to install."
	# integration
	local ENVDFILE=50xulrunner
	echo 'LDPATH="/opt/xulrunner"' > "${T}/${ENVDFILE}"
	echo 'MOZILLA_FIVE_HOME="/opt/xulrunner"' >> "${T}/${ENVDFILE}"
	doenvd "${T}/${ENVDFILE}"
}
