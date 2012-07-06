# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Hewlett-Packard Compaq 6510b/6710b keycodes for kernel, HAL and udev."
HOMEPAGE="https://rychly.homeip.net/wiki/notebook*keyboard"
SRC_URI=""

KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 x86-fbsd"
IUSE="hal udev"
SLOT="0"
RDEPEND="hal? ( sys-apps/hal )
	udev? ( sys-fs/udev )"

src_install() {
	# init.d
	local initd_name
	initd_name="${PN%%-*}"
	newinitd "${FILESDIR}/v${PV}-etc_init.d_keycodes" "${initd_name}"
	newconfd "${FILESDIR}/v${PV}-etc_conf.d_keycodes" "${initd_name}"
	# hal
	if use hal; then
		dodir "/etc/hal/fdi/information"
		cp "${FILESDIR}/v${PV}-etc_hal_fdi_information_input-keymap-hp6510.fdi" "${D}/${INSTALLDIR}/etc/hal/fdi/information/input-keymap-hp6510.fdi"
	fi
	# udev
	if use udev; then
		dodir "/etc/udev/rules.d"
		cp "${FILESDIR}/v${PV}-etc_udev_rules.d_99-keymap-hp6510b_6710b.rules" "${D}/${INSTALLDIR}/etc/udev/rules.d/99-keymap-hp6510b_6710b.rules"
		dodir "/lib/udev/keymaps"
		cp "${FILESDIR}/v${PV}-lib_udev_keymaps_hewlett-packard-6510b_6710b" "${D}/${INSTALLDIR}/lib/udev/keymaps/hewlett-packard-6510b_6710b"
	fi
}
