# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Hewlett-Packard Compaq 6510b/6710b keymap for kernel and udev."
HOMEPAGE="https://rychly.us.to/wiki/notebook*keyboard"
LICENSE="GPL-2"

KEYWORDS="x86 amd64"
IUSE="+openrc +udev"
SLOT="0"
RDEPEND="openrc? ( sys-apps/kbd )
	udev? ( virtual/udev )"

src_install() {
	# openrc/init.d
	if use openrc; then
		newinitd "${FILESDIR}/${PR}-${PN}.initd" "${PN}"
		newconfd "${FILESDIR}/${PR}-${PN}.confd" "${PN}"
	fi
	# udev
	if use udev; then
		local udevdir="$($(tc-getPKG_CONFIG) --variable=udevdir udev)"
		dodir "${udevdir}/keymaps"
		cp "${FILESDIR}/${PR}-${PN}.keymaps" "${D}/${INSTALLDIR}/${udevdir}/keymaps/hewlett-packard-6510_6710"
		dodir "${udevdir}/rules.d"
		cp "${FILESDIR}/${PR}-${PN}.rulesd" "${D}/${INSTALLDIR}/${udevdir}/rules.d/96-${PN}.rules"
	fi
	# hal
	#if use hal; then
	#	dodir "/etc/hal/fdi/information"
	#	cp "${FILESDIR}/${PR}-${PN}.fdi" "${D}/${INSTALLDIR}/etc/hal/fdi/information/${PN}.fdi"
	#fi
}
