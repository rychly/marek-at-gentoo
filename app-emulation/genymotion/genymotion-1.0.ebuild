# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Genymotion is a complete set of tools that provides a virtual environment for Android."
HOMEPAGE="http://www.genymotion.com/"
SRC_URI="x86? ( https://genymotion-genymobile.netdna-ssl.com/launchpad/genymotion-${PV}_x86.bin )
	amd64? ( https://genymotion-genymobile.netdna-ssl.com/launchpad/genymotion-${PV}_x64.bin )"

RESTRICT="mirror"
LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="|| ( >=app-emulation/virtualbox-4.1 >=app-emulation/virtualbox-bin-4.1 )
	media-libs/libpng:1.2"

DEPEND="${RDEPEND}"

src_unpack() {
	local dist="${DISTDIR}/${A}"
	# Retrieve line number where tar.bzip2 binary begins
	local skip=$(awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' "${dist}")
	[ $? -ne 0 ] && die "Unable to locate tar.bzip2 content!"
	# Untar following archive
	tail -n +$skip "${dist}" | tar -xj -C "${WORKDIR}" || die "Unable to extract tar.bzip2 content!"
}

src_install() {
	local INSTALLDIR=/opt/${PN}
	dodir "${INSTALLDIR}"
	# move files
	mv "${WORKDIR}"/gui/* "${D}/${INSTALLDIR}/" || die "Cannot install GUI!"
	rm -r "${WORKDIR}/gui"
	mv "${WORKDIR}"/* "${D}/${INSTALLDIR}/" || die "Cannot install Shell!"
	# fix permissions
	chmod 644 "${D}/${INSTALLDIR}/libprotobuf.so.7" "${D}/${INSTALLDIR}/imageformats"/* "${D}/${INSTALLDIR}/plugins"/*
	find "${D}/${INSTALLDIR}" -type d -exec chmod a+rx {} \;
	find "${D}/${INSTALLDIR}" -type f -exec chmod a+r {} \;
	find "${D}/${INSTALLDIR}" -type f -perm /u=x -exec chmod a+x {} \;
	# make executables accessible
	dodir "/etc/env.d"
	echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	make_desktop_entry "${INSTALLDIR}/genymotion" "Genymotion" "${INSTALLDIR}/icons/icon.png" "Development"
}
