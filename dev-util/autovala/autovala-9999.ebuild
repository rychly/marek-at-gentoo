# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

VALA_MIN_API_VERSION=0.20

inherit cmake-utils git-2 vala

DESCRIPTION="A program and a library designed to help in the creation of projects with Vala and CMake."
HOMEPAGE="https://github.com/rastersoft/autovala/"

EGIT_REPO_URI="https://github.com/rastersoft/${PN} git://github.com/rastersoft/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm ~x86 ~amd64"
IUSE="pandoc"

RDEPEND="dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf:2
	dev-libs/libgee:0.8
	x11-libs/pango
	pandoc? ( app-text/pandoc )"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_unpack() {
	git-2_src_unpack
	cd "${S}"
}

src_prepare() {
	# disable pandoc (markdown -> html and man pages)
	if ! use pandoc; then
		epatch "${FILESDIR}/no-pandoc.patch"
		sed -i 's/^\(add_subdirectory(wiki)\)$/#\1/g' "${S}/CMakeLists.txt" || die "Unable to remove wiki requiring pandoc!"
	fi
	# inicialize Vala
	vala_src_prepare
	local VALAVER=${VALAC##*-}
	sed -i "s/^\\(\\s*NAMES valac\\)\\()\\)\$/\\1-${VALAVER}\\2/g" "${S}/cmake/FindVala.cmake" || die "Unable to patch for valac binnary!"
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cd "${S}_build"
	make ${MAKEOPTS} VERBOSE=1
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	#dosym ${VALAC} /usr/bin/valac
}

pkg_postinst() {
	local VALACSYMLINK=/usr/bin/valac
	einfo "Autovala requires valac binnary without -version suffix, creating symlink:"
	einfo "	${VALACSYMLINK} -> ${VALAC}"
	ln -s ${VALAC} ${VALACSYMLINK} || die "Unable to create the symlink!"
}
