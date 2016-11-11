# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit cmake-utils vala

## will be downloaded directly from the repository's web-server via HTTP, DARCS not needed
#inherit darcs

DESCRIPTION="System tray companion for kbdd."
HOMEPAGE="http://hub.darcs.net/zabbal/ktc"
EDARCS_REPOSITORY="http://hub.darcs.net/zabbal/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/kbdd[dbus]
	sys-apps/dbus"
DEPEND="${RDEPEND}
	net-misc/wget
	dev-util/autovala
	x11-libs/libnotify
	dev-libs/dbus-glib
	dev-util/vala-dbus-binding-tool"

darcsden_download() {
	local SRC="${1}"
	local DST="${2}"
	echo "Fetching ${SRC} into ${DST} ..."
	local URLS=$(wget "${SRC}" -O - | \
		grep -o 'class="\(directory\|file\)"\|[^"]*/browse/[^"]*' | \
		tr '\n' ' ' | \
		sed 's/class="\([^"]\)[^"]*" \([^ ]*\) /\1|\2\n/g' \
	)
	[[ $? -eq 0 ]] || return -1
	mkdir -p "${DST}"
	for I in ${URLS}; do
		local TYPE="${I:0:1}"
		local URL="${I:2}"
		if [[ "${TYPE}" == 'f' ]]; then
			wget --directory-prefix="${DST}" "${URL//\/browse\///raw/}" || return -2
		elif [[ "${TYPE}" == 'd' ]]; then
			darcsden_download "${URL}/" "${DST}/$(basename ${URL})"
			[[ $? -eq 0 ]] || return $?
		fi
	done
	return 0
}

src_unpack() {
	mkdir "${S}"
	darcsden_download "${EDARCS_REPOSITORY}" "${S}" || die "Cannot download source files from the repository!"
}

src_prepare() {
	# inicialize Vala
	vala_src_prepare
	local VALAVER=${VALAC##*-}
	sed -i "s/^\\(\\s*NAMES valac\\)\\()\\)\$/\\1-${VALAVER}\\2/g" "${S}/cmake/FindVala.cmake" || die "Cannot fix valaversion in cmake/FindVala.cmake"
	# disable dbus introspection
	sed -i 's/^\(dbus_interface:.*\)$/#\1/g' "${S}/ktc.avprj" || die "Cannot disable dbus introspection in ktc.avprj"
	# disable autovala icon actions
	sed -i 's/^\(\*full_icon:.*\)$/#\1/g' "${S}/ktc.avprj" || die "Cannot disable autovala icon actions in ktc.avprj"
}

src_configure() {
	# autovala
	autovala cmake
	# generate dbus bindings
	mkdir -p "${S}/src/dbus_generated/ru.gentoo.KbddService/ru/gentoo/KbddService"
	vala-dbus-binding-tool --gdbus --api-path=/usr/share/dbus-1/interfaces/kbdd-service-interface.xml "--directory=${S}/src/dbus_generated/ru.gentoo.KbddService/ru/gentoo/KbddService" \
	|| die "Unable to generate dbus vala bindings"
	sed -i "s|^\\(set (APP_SOURCES \${APP_SOURCES} kbdd_tray_companion.vala)\\)$|\1\nset (APP_SOURCES \${APP_SOURCES} dbus_generated/ru.gentoo.KbddService/ru/gentoo/KbddService/ru-gentoo.vala)|" \
		"${S}/src/CMakeLists.txt"
	# cmake
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	local flagsdir=/usr/share/icons/hicolor/scalable/intl
	cmake-utils_src_install
	dodoc README
	make_desktop_entry "ktc --flags=.icons/flags --extension=.svg --libnotify-time=220" \
		"KBDD tray companion" "preferences-desktop-keyboard" "System"
	## BUG: a value of arg --flags is always prefixed with ${HOME}, so it cannot be an absolute path to ${flagsdir} => need not to install there
	#dodir "${flagsdir}"
	#mv "${S}/data/icons"/*.svg "${D}${flagsdir}" || die "Cannot install flag icons."
}
