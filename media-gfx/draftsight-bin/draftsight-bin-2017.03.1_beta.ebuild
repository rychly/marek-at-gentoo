# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# based on http://data.gpo.zugaina.org/betagarden/media-gfx/draftsight-bin/draftsight-bin-1.6.1_beta.ebuild

EAPI=2

inherit eutils

PV_MAJOR="${PV%%.*}"
PV_AFTER_MAJOR="${PV#*.}" PV_MINOR="${PV_AFTER_MAJOR%_*}"
[[ "${PV%%.*}" -gt 0 ]] && PV_SP="SP${PV_MINOR//./-}"

DESCRIPTION="Professional 2D CAD application, supporting DWT, DXF and DWG."
HOMEPAGE="http://www.3ds.com/products/draftsight/free-cad-software/"
SRC_URI_WEBPAGE="http://www.3ds.com/products-services/draftsight-cad-software/free-download/"
SRC_URI="http://dl-ak.solidworks.com/nonsecure/draftsight/${PV_MAJOR}${PV_SP}/draftSight.deb -> ${P}.deb"

LICENSE="draftsight-eula"
SLOT="0"
KEYWORDS="amd64"
IUSE="apisdk"

RESTRICT="mirror strip binchecks"
#RESTRICT+=" fetch"
DEPEND=""
RDEPEND="sys-libs/zlib
	net-print/cups
	dev-libs/expat
	dev-libs/glib:2
	media-libs/glu
	media-libs/phonon
	media-libs/alsa-lib
	media-libs/fontconfig
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt"
#	media-libs/nas

INSTALLDIR="/opt/DraftSight"

pkg_nofetch() {
	einfo "Upstream has a mandatory EULA agreement to download this file."
	einfo "Please navigate your browser to:"
	einfo "${SRC_URI_WEBPAGE}"
	einfo "Click 'Download DraftSight ${PV_MAJOR} for Ubuntu (beta)'"
	einfo "Download the deb file and move it to ${DISTDIR}/${A}"
}

src_unpack() {
	unpack ${A}
	tar -xzf "${WORKDIR}/data.tar.gz" || tar -xJf "${WORKDIR}/data.tar.xz"
}

src_prepare() {
	use apisdk || rm -rf opt/dassault-systemes/DraftSight/APISDK
	sed -i "s|/opt/dassault-systemes/DraftSight/|${INSTALLDIR}/|g" opt/dassault-systemes/DraftSight/Resources/dassault-systemes_draftsight.desktop
}

src_install() {
	# icons and desktop
	for I in 16 32 48 64 128; do
		#newicon -s "${I}" "opt/dassault-systemes/DraftSight/Resources/pixmaps/${I}x${I}/program.png" draftsight.png
		dosym "${INSTALLDIR}/Resources/pixmaps/${I}x${I}/program.png" "/usr/share/icons/hicolor/${I}x${I}/apps/draftsight.png"
	done
	make_desktop_entry "${INSTALLDIR}/Linux/DraftSight" "DraftSight" "draftsight" "Graphics;2DGraphics;RasterGraphics;"
	# application
	dodir "${INSTALLDIR%/*}"
	mv opt/dassault-systemes/DraftSight "${D}/${INSTALLDIR}" || die "Cannot install files"
	# TODO: work around NULL DT_PATH and relative DT_RPATH '../Libraries' security issue in ${INSTALLDIR}/Libraries/* by chdir'ing into expected ${LD_LIBRARY_PATH}, i.e., ${INSTALLDIR}/Linux
	dosym "${INSTALLDIR}/Linux/DraftSight" /usr/bin/DraftSight
}
