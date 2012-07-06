# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fdo-mime rpm multilib

DESCRIPTION="OpenOffice development suite (binary)"
HOMEPAGE="http://go-oo.org/"

VER_URE="1.6.0"
VER_PKG="${PV%_p*}"
VER_DIR="${VER_PKG%.0}"
VER_APP="${VER_PKG%.*}"
VER_MAJ="${PV%%.*}"
VER_BLD="${PV#*_p}"

LANGS="cs da de en es fr he hu ja ko pl ru sv zh_CN zh_TW"
#LANGS="${LANGS} af ar bn_IN ca en_GB el fi gu_IN hi_IN it mr_IN nb nl nn pt pt_BR sk ta_IN xh zu"
SRC_BASE="http://go-oo.mirrorbrain.org/stable/linux"
for i in base binfilter calc core01 core02 core03 core04 core05 core06 core07 draw graphicfilter images impress math ooofonts ooolinguistic pyuno testtool writer xsltfilter; do
	SRC_URI_x86="${SRC_URI_x86}
		${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-${i}-${VER_PKG}-${VER_BLD}.i586.rpm"
	SRC_URI_amd64="${SRC_URI_amd64}
		${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-${i}-${VER_PKG}-${VER_BLD}.x86_64.rpm"
done
for i in base calc draw impress math writer; do
	SRC_URI_x86="${SRC_URI_x86}
		${SRC_BASE}-x86/${VER_DIR}/openoffice.org${VER_MAJ}-${i}-${VER_PKG}-${VER_BLD}.i586.rpm"
	SRC_URI_amd64="${SRC_URI_amd64}
		${SRC_BASE}-x86_64/${VER_DIR}/openoffice.org${VER_MAJ}-${i}-${VER_PKG}-${VER_BLD}.x86_64.rpm"
done
for k in ${LANGS}; do
	i="${k/_/-}"
	[[ ${i} = "en" ]] && i="en-US"
	SRC_URI_x86="${SRC_URI_x86}
		linguas_${k}?	( ${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-${i}-${VER_PKG}-${VER_BLD}.i586.rpm )
		linguas_${k}?	( ${SRC_BASE}-x86/${VER_DIR}/openoffice.org${VER_MAJ}-${i}-${VER_PKG}-${VER_BLD}.i586.rpm )"
	SRC_URI_amd64="${SRC_URI_amd64}
		linguas_${k}?	( ${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-${i}-${VER_PKG}-${VER_BLD}.x86_64.rpm )
		linguas_${k}?	( ${SRC_BASE}-x86_64/${VER_DIR}/openoffice.org${VER_MAJ}-${i}-${VER_PKG}-${VER_BLD}.x86_64.rpm )"
	for j in base binfilter calc draw help impress math res writer; do
		SRC_URI_x86="${SRC_URI_x86}
			linguas_${k}?	( ${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-${i}-${j}-${VER_PKG}-${VER_BLD}.i586.rpm )"
		SRC_URI_amd64="${SRC_URI_amd64}
			linguas_${k}?	( ${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-${i}-${j}-${VER_PKG}-${VER_BLD}.x86_64.rpm )"
	done
done
SRC_URI_x86="${SRC_URI_x86}
	${SRC_BASE}-x86/${VER_DIR}/openoffice.org${VER_MAJ}-${VER_PKG}-${VER_BLD}.i586.rpm
	${SRC_BASE}-x86/${VER_DIR}/openoffice.org-ure-${VER_URE}-${VER_BLD}.i586.rpm
	gnome?	( ${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-gnome-integration-${VER_PKG}-${VER_BLD}.i586.rpm )
	kde?	( ${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-kde-integration-${VER_PKG}-${VER_BLD}.i586.rpm )
	java?	( ${SRC_BASE}-x86/${VER_DIR}/ooobasis${VER_APP}-javafilter-${VER_PKG}-${VER_BLD}.i586.rpm )"
SRC_URI_amd64="${SRC_URI_amd64}
	${SRC_BASE}-x86_64/${VER_DIR}/openoffice.org${VER_MAJ}-${VER_PKG}-${VER_BLD}.x86_64.rpm
	${SRC_BASE}-x86_64/${VER_DIR}/openoffice.org-ure-${VER_URE}-${VER_BLD}.x86_64.rpm
	gnome?	( ${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-gnome-integration-${VER_PKG}-${VER_BLD}.x86_64.rpm )
	kde?	( ${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-kde-integration-${VER_PKG}-${VER_BLD}.x86_64.rpm )
	java?	( ${SRC_BASE}-x86_64/${VER_DIR}/ooobasis${VER_APP}-javafilter-${VER_PKG}-${VER_BLD}.x86_64.rpm )"
SRC_URI="${SRC_BASE}-x86/${VER_DIR}/openoffice.org${VER_APP}-freedesktop-menus-${VER_APP}-${VER_BLD}.noarch.rpm
	x86?	( ${SRC_URI_x86} )
	amd64?	( ${SRC_URI_amd64} )"

IUSE="gnome java kde"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip mirror"

RDEPEND="!app-office/openoffice
	!app-office/openoffice-bin
	x11-libs/libXaw
	sys-libs/glibc
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	>=media-libs/freetype-2.1.10-r2
	java? ( >=virtual/jre-1.5 )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PROVIDE="virtual/ooo"

QA_EXECSTACK="usr/$(get_libdir)/openoffice/basis3.0/program/*"
QA_TEXTRELS="usr/$(get_libdir)/openoffice/basis3.0/program/libvclplug_genli.so \
	usr/$(get_libdir)/openoffice/basis3.0/program/python-core-2.3.4/lib/lib-dynload/_curses_panel.so \
	usr/$(get_libdir)/openoffice/basis3.0/program/python-core-2.3.4/lib/lib-dynload/_curses.so \
	usr/$(get_libdir)/openoffice/ure/lib/*"

src_unpack() {
	rpm_src_unpack
}

src_install () {
	INSTDIR="/usr/$(get_libdir)/openoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/openoffice.org/* "${D}${INSTDIR}" || die
	mv "${WORKDIR}"/opt/openoffice.org3/* "${D}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/share/xdg/"

	for desk in base calc draw impress math printeradmin qstart writer; do
		mv ${desk}.desktop openoffice.org-${desk}.desktop
		sed -i -e s/openoffice.org3/ooffice/g openoffice.org-${desk}.desktop || die
		sed -i -e s/openofficeorg3-${desk}/ooo-${desk}/g openoffice.org-${desk}.desktop || die
		domenu openoffice.org-${desk}.desktop
		insinto /usr/share/pixmaps
		if [ "${desk}" != "qstart" ] ; then
			newins "${WORKDIR}/usr/share/icons/gnome/48x48/apps/openofficeorg3-${desk}.png" ooo-${desk}.png
		fi
	done

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}/usr/bin/ooffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/oo${app}
	done

	dosym ${INSTDIR}/program/spadmin.bin /usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	rm -f ${INSTDIR}/basis-link || die
	dosym ${INSTDIR}/basis${VER_APP} ${INSTDIR}/basis-link

	# Change user install dir
	sed -i -e "s/.openoffice.org\/3/.ooo3/g" "${D}${INSTDIR}/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/program/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-openoffice-bin"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	elog " openoffice-bin does not provide integration with system spell "
	elog " dictionaries. Please install them manually through the Extensions "
	elog " Manager (Tools > Extensions Manager) or use the source based "
	elog " package instead. "
	elog

	ewarn " Please note that this release of OpenOffice.org uses a "
	ewarn " new user install dir. As a result you will have to redo "
	ewarn " your settings. Alternatively you might copy the old one "
	ewarn " over from ~/.ooo-2.0 to ~/.ooo3, but be warned that this "
	ewarn " might break stuff. "
	ewarn
}