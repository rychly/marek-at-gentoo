# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Acer Aspire 5033 patch for X keyboard configuration database"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 x86-fbsd"
HOMEPAGE="http://rychly.iglu.cz/doku.php?id=notebook:keyboard"
SRC_URI=""

SLOT="0"

RDEPEND="=x11-misc/xkeyboard-config-${PV}"

src_unpack() {
	mkdir -p "${WORKDIR}/usr/share/X11/xkb/rules" "${WORKDIR}/usr/share/X11/xkb/symbols"
	local I F
	for I in "${FILESDIR}"/v${PV}-*.patch; do
		F=$(basename "$I")
		F=${F#v${PV}-}
		F=${F%.patch}
		F=${F//_//}
		if [ -L "/usr/share/X11/xkb/${F}" ]; then
			cp "/usr/share/X11/xkb/${F}.without-${P}" \
			"${WORKDIR}/usr/share/X11/xkb/${F}" \
			|| die "Cannot copy original ${F}.without-${P} (emerge x11-misc/xkeyboard-config)"
		else
			cp "/usr/share/X11/xkb/${F}" \
			"${WORKDIR}/usr/share/X11/xkb/${F}" \
			|| die "Cannot copy original ${F} (emerge x11-misc/xkeyboard-config)"
		fi
	done
}

src_compile() {
	cd "${WORKDIR}"
	local I F
	for I in "${FILESDIR}"/v${PV}-*.patch; do
		epatch "${I}" || die "Cannot patch ${I}"
		F=$(basename "$I")
		F=${F#v${PV}-}
		F=${F%.patch}
		F=${F//_//}
		mv "${WORKDIR}/usr/share/X11/xkb/${F}" \
		"${WORKDIR}/usr/share/X11/xkb/${F}.with-${P}" \
		|| die "Cannot rename patched ${F} in WORKDIR"
	done
}

src_install() {
	mv "${WORKDIR}"/* "${D}/" || die "Cannot install"
}

pkg_postinst() {
	elog ""
	elog "To enable/disable usage configuration"
	ewarn "	emerge --config =${CATEGORY}/${P}"
	elog ""
}

pkg_prerm() {
	local F
	F=$(ls "/usr/share/X11/xkb"/*/*.without-${P})
	if [ -n "${F}" ]; then
		ewarn "Configuration backups detected:"$'\n'"${F}"
		elog ""
		elog "Before unmerging, it is recommended to disable the package's usage via"
		ewarn "	emerge --config =${CATEGORY}/${P}"
		elog ""
		elog "To continue unmerging hit Enter, or Control-C to abort now..."
		read
	fi
}

pkg_config() {
	local I F
	einfo "To enable enter 'enable' and to disable enter 'disable':"
	read I
	if [ "${I}" == "enable" ]; then
		for I in "/usr/share/X11/xkb"/*/*.with-${P}; do
			[ -e "${I}" ] || break
			F=${I%.with-${P}}
			einfo "	${F}"
			if [ -f "${F}" -a ! -f "${F}.without-${P}" ]; then
				mv "${F}" "${F}.without-${P}" \
				|| die "Cannot backup ${F}"
				ln -s $(basename "${I}") "${F}" \
				|| die "Cannot link ${I}"
				einfo "	-> ${I}"
			fi
		done
		einfo "Done."
		elog ""
		elog "Use in xorg.conf as"
		ewarn "	Option \"XkbModel\" \"aspire5033\""
		elog ""
	elif [ "${I}" == "disable" ]; then
		for I in "/usr/share/X11/xkb"/*/*.without-${P}; do
			[ -e "${I}" ] || break
			F=${I%.without-${P}}
			einfo "	${F}"
			if [ -L "${F}" ]; then
				mv "${I}" "${F}" \
				|| die "Cannot restore ${F}"
				einfo "	-> ${I}"
			fi
		done
		einfo "Done."
	else
		ewarn "Uknown choice."
	fi
}