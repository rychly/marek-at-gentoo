# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Automounter of storage devices which utilise (kernel) autofs automounter and udev events."
HOMEPAGE="https://rychly.homeip.net/wiki/notebook*automounter"

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 x86-fbsd"
IUSE=""
SLOT="0"
RDEPEND="net-fs/autofs
	sys-fs/udev"

src_unpack() {
	cd "${WORKDIR}"
	## autofs
	local MOUNTPOINT_BASE=$(grep -o '^MOUNTPOINT_BASE=.*$' "${FILESDIR}/${PR}-${PN}.etc" | cut -d = -f 2)
	local AUTOFS_MAP=$(grep -o '^AUTOFS_MAP=.*$' "${FILESDIR}/${PR}-${PN}.etc" | cut -d = -f 2)
	local autofscfg="/etc/autofs/auto.master"
	[ -e "${autofscfg}" ] \
		&& cp "${autofscfg}" "${WORKDIR}"
	grep -q "${AUTOFS_MAP}" "${WORKDIR}/$(basename ${autofscfg})" 2>/dev/null \
		|| echo "#${MOUNTPOINT_BASE}	${AUTOFS_MAP}	--ghost --timeout=10" >>"${WORKDIR}/$(basename ${autofscfg})"
	## udev
	# scripts will be installed into udevdir which is included in PATH of commands invoked by udev rules, no modification required
}

src_install() {
	local autofscfg="/etc/autofs/auto.master"
	dodir "$(dirname ${autofscfg})"
	cp "${FILESDIR}/${PR}-${PN}.etc" "${D}/etc/${PN}"
	cp "${WORKDIR}/$(basename ${autofscfg})" "${D}/${autofscfg}"
	local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	dodir "${udevdir}/rules.d"
	cp "${FILESDIR}/${PR}-${PN}.rules" "${D}/${udevdir}/rules.d/61-${PN}.rules"
	cp "${FILESDIR}/${PR}-${PN}-mount.sh" "${D}/${udevdir}/${PN}-mount.sh"
	cp "${FILESDIR}/${PR}-${PN}-umount.sh" "${D}/${udevdir}/${PN}-umount.sh"
	cp "${FILESDIR}/${PR}-${PN}-reload.sh" "${D}/${udevdir}/${PN}-reload.sh"
}

pkg_postinst() {
	local autofscfg="/etc/autofs/auto.master"
	local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
	einfo ""
	einfo "To finish the ${P} installation you need uncomment the ${PN} autofs map in:"
	ewarn "	${autofscfg}"
	einfo "and execute the following script to reload autofs and udev rules:"
	ewarn "	${udevdir}/${PN}-reload.sh"
	einfo ""
	einfo "Also check the following ${PN} configuration file:"
	ewarn "	/etc/${PN}"
	einfo ""
}
