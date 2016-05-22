# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils

## Service Release 2013_05 (843889)
TMP=${PV%_*} MY_VER=${TMP//./}
MY_BLD=${PV#*_p}
MY_IDX=79

DESCRIPTION="ARIS Client (ARIS Platform) for use with approved Linux operating systems"
HOMEPAGE="http://www.softwareag.com/corporate/products/aris/default.asp"
SRC_URI="http://aris.softwareag.com/ARISDownloadCenter?downloadfile=ARIS${MY_VER}_PLATFORM_${MY_BLD}.tar.gz&downloadfileindex=${MY_IDX} -> ARIS${MY_VER}_PLATFORM_${MY_BLD}.tar.gz"

RESTRICT="mirror"
LICENSE="software-ag"
SLOT="0"
KEYWORDS="x86 amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.5"

INSTALLDIR=/opt/${PN}

src_unpack() {
	unpack ${A}
	local dist="${WORKDIR}/ARIS Platform/install_ARIS_${MY_VER:0:2}.${MY_BLD}.sh"
	# Retrieve line number where tar.gzip binary begins
	local skip=$(grep --text -o '^OFFSET=[0-9]*$' -m 1 "${dist}" | cut -d '=' -f 2)
	[ $? -ne 0 ] && die "Unable to locate tar.gzip content!"
	# Untar following archive
	tail -c +$skip "${dist}" | tar -xz -C "${WORKDIR}" && rm -rf "${dist%/*}" || die "Unable to extract tar.gzip content!"
}

src_prepare() {
	# Fix white-spaces in script names
	for I in "${WORKDIR}"/*.sh; do
		mv "${I}" "${I// /_}" 2>/dev/null
	done
	# Remove bundled JRE
	rm -rf "${WORKDIR}/jre"
	sed -i 's/^\(\(export \)\{0,1\}JAVA_HOME.*\)$/#\1/g' "${WORKDIR}"/*.sh
	sed -i \
		-e 's:\(jvmPath="\)[^"]*\("\):\1/etc/java-config-2/current-system-vm\2:g' \
		-e 's:\(jars="\)[^"]*\(/lib"\):\1'"${INSTALLDIR}"'\2:g' \
		"${WORKDIR}/config/launcher.cfg"
}

src_install() {
	dodir "${INSTALLDIR}"
	# copy/move files
	mv "${WORKDIR}"/* "${D}/${INSTALLDIR}/" || die "Cannot install the application!"
	cp "${FILESDIR}"/*.gif "${D}/${INSTALLDIR}/" || die "Cannot install icons!"
	# make executables accessible
	#dodir "/etc/env.d"
	#echo -e "PATH=${INSTALLDIR}\nROOTPATH=${INSTALLDIR}" > "${D}/etc/env.d/10${PN}"
	for I in "${D}/${INSTALLDIR}"/ARIS*.sh; do
		local basename=$(basename "${I}" .sh)
		if [ "${basename#ARIS_Business_Architect}" != "${basename}" ]; then
			local icon="${INSTALLDIR}/architect.gif"
		elif [ "${basename#ARIS_Business_Designer}" != "${basename}" ]; then
			local icon="${INSTALLDIR}/designer.gif"
		else
			local icon=
		fi
		make_desktop_entry "${INSTALLDIR}/${basename}.sh" "${basename//_/ }" "${icon}" "Development"
	done
}
