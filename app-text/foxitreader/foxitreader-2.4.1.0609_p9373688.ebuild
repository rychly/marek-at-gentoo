# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# adapted from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=foxitreader

EAPI=5

inherit eutils

MY_PV1=${PV%%_p*}
MY_PV2=${PV%.*.*}
# to get the patch version, extract *.tar.gz, get the revision number in the brackets of the extracte filename, and convert it into a decimal number, e.g., by: echo $((0x1234))
MY_PVB=$(printf '%07x' ${PV##*_p})

DESCRIPTION="A free PDF document viewer, featuring small size, quick startup, and fast page rendering"
HOMEPAGE="https://www.foxitsoftware.cn/downloads/"
SRC_URI_BASE="http://cdn09.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x"
SRC_URI="x86? ( ${SRC_URI_BASE}/${MY_PV2}/en_us/FoxitReader${MY_PV1}_Server_x86_enu_Setup.run.tar.gz )
	amd64? ( ${SRC_URI_BASE}/${MY_PV2}/en_us/FoxitReader${MY_PV1}_Server_x64_enu_Setup.run.tar.gz )"

LICENSE="${PN}"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="-systemlibs"

DEPEND="app-arch/p7zip"

RDEPEND="systemlibs? ( app-crypt/libsecret
		dev-libs/libxslt
		media-libs/gstreamer:0.10
	)
	x11-libs/libXcomposite
	media-libs/mesa
	x11-libs/libXrender
	x11-libs/libXi
	x11-libs/libSM
	media-libs/fontconfig
	sys-apps/dbus
	dev-libs/openssl:0"

S="${WORKDIR}"
INSTALLDIR="/opt/${PN}"
QA_PREBUILT="${INSTALLDIR}/*"

exclude_files() {
	local _line
	while IFS='' read -r _line; do
		if [ "${_line::2}" = "# " ]; then
			einfo "Removing excluded files from ${_line:2}..."
		elif [ -n "${_line}" -a "${_line::1}" != "#" ]; then
			rm "${S}/${PN}-build/${_line}"
		fi
	done < $@
}

src_prepare() {
	local _file
	local _position
	# Clean installer dir
	[ -d "${PN}-installer" ] && rm -rf "${PN}-installer"
	mkdir "${PN}-installer"
	# Decompress .run installer
	if use x86; then
		_file="FoxitReader.enu.setup.${MY_PV1}(r${MY_PVB}).x86.run"
	else
		_file="FoxitReader.enu.setup.${MY_PV1}(r${MY_PVB}).x64.run"
	fi
	for _position in `grep --only-matching --byte-offset --binary --text $(printf '7z\xBC\xAF\x27\x1C') "${_file}" | cut -f1 -d:`; do
		einfo "Unpacking from offset ${_position} in ${_file} ..."
		dd if="${_file}" \
			bs=1M iflag=skip_bytes status=none skip=${_position} \
			of="${PN}-installer/bin-${_position}.7z"
	done
	# Clean build dir
	[ -d "${PN}-build" ] && rm -rf "${PN}-build"
	# Decompress 7z files (some files are damaged during the extraction)
	cd "${PN}-installer"
	install -m 755 -d "${S}/${PN}-build"
	for _file in *.7z; do
		7z -bd -bb0 -y x -o"${S}/${PN}-build" ${_file} 1>/dev/null 2>&1 || true
	done
	# Apply final patches
	cd "${S}/${PN}-build"
	epatch "${FILESDIR}/${PN}.patch"
	# Remove unneeded files
	rm "Activation" "Activation.desktop" "Activation.sh" \
		"countinstalltion" "countinstalltion.sh" \
		"installUpdate" "ldlibrarypath.sh" \
		"maintenancetool.sh" "Uninstall.desktop" \
		"Update.desktop" "updater" "updater.sh"
	find -type d -name ".svn" -exec rm -rf {} +
	find -type f -name ".directory" -exec rm -rf {} +
	find -type f -name "*~" -exec rm {} +
	# Remove excluded files
	exclude_files "${FILESDIR}/${PN}-excluded_files1"
	use systemlibs && exclude_files "${FILESDIR}/${PN}-excluded_files2"
}

src_install() {
	local _icon
	local _size
	# Integrate into desktop
	for _icon in "${S}/${PN}-build/images"/FoxitReader-*x*.png; do
		_size="${_icon##*-}"
		_size="${_size%%.*}"
		newicon -s "${_size}" "${_icon}" "${PN}.png"
	done
	newmenu "${S}/${PN}-build/FoxitReader.desktop" "${PN}.desktop"
	# Install binaries
	dodir "${INSTALLDIR%/*}"
	mv "${S}/${PN}-build" "${D}${INSTALLDIR}" || die "Cannot move the installed files!"
	dosym "${INSTALLDIR}/FoxitReader.sh" "/usr/bin/${PN}"
}
