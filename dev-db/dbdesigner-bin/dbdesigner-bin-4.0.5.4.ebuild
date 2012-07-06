# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A visual database design system that integrates database design, modeling, creation and maintenance into a single, seamless environment."
HOMEPAGE="http://fabforce.net/dbdesigner4/"
SRC_URI="mirror://mysql/DBDesigner4/DBDesigner${PV}.tar.gz
	mirror://sourceforge/kylixlibs/kylixlibs3-borqt-3.0-2.tar.gz"

KEYWORDS="x86 amd64"
SLOT="${PV%%.*}"
IUSE=""
LICENSE="GPL-2"
DEPEND=""
RDEPEND=""
RESTRICT="nomirror"

S="${WORKDIR}/DBDesigner${PV%%.*}"
INSTALLDIR="/opt/${PN}"
LIBLINKS="bplrtl.so.6.9.0:bplrtl.so.6.9 dbxres.en.1.0:dbxres.en.1 libmidas.so.1.0:libmidas.so.1 \
libmysqlclient.so.10.0.0:libmysqlclient.so libqt.so.2.3.2:libqt.so.2 libqtintf-6.9.0-qt2.3.so:libqtintf-6.9-qt2.3.so \
libsqlmy23.so.1.0:libsqlmy23.so libsqlmy23.so:libsqlmy.so libsqlora.so.1.0:libsqlora.so libDbxSQLite.so.2.8.5:libDbxSQLite.so \
liblcms.so.1.0.9:liblcms.so libpng.so.2.1.0.12:libpng.so.2 libstdc++.so.5.0.0:libstdc++.so.5 \
libborqt-6.9.0-qt2.3.so:libborqt-6.9-qt2.3.so"

src_unpack() {
	unpack ${A}
	cp -f "${FILESDIR}/DBDesigner${PV%%.*}_Settings.ini" "${S}/Data/" || die "Unable to copy config file"
	cp "${WORKDIR}/kylixlibs3-borqt/libborqt-6.9.0-qt2.3.so" "${S}/Linuxlib/" || die "Unable to copy KylixLibs"
	local l;
	for l in ${LIBLINKS}; do
		ln -s "${l%%:*}" "${S}/Linuxlib/${l##*:}" || die "Unable to create a symlink to library '$l'"
	done
	cp "${FILESDIR}/DBDesigner${PV%%.*}.sh" "${S}" || die "Unable to copy application starter"
	sed -e "s:/home/mike/../mike/DBDesigner${PV%%.*}:${INSTALLDIR}:g" -e "s:/startdbd\$:/DBDesigner${PV%%.*}.sh:g" "${S}/startdbd.desktop" \
	>"${S}/DBDesigner${PV%%.*}.desktop" && rm "${S}"/startdbd*
	find "${S}" -type d | xargs chmod 755
	find "${S}" -type f | xargs chmod 644
	chmod 755 "${S}/DBDesigner4" "${S}/DBDesigner4.sh" "${S}"/DBDplugin_*
}

src_install() {
	dodir "${INSTALLDIR}"
	mv "${S}"/* "${D}/${INSTALLDIR}"

	domenu "${D}/${INSTALLDIR}/DBDesigner${PV%%.*}.desktop"

	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
}
