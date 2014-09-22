# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Closed-source tools provided by Rockchip for upgrading update.img, parameter, bootloader and other partitions."
HOMEPAGE="http://wiki.radxa.com/Rock/flash_the_image#Upgrade_tool_from_Rockchip"
SRC_URI="http://dl.radxa.com/rock/tools/linux/Linux_Upgrade_Tool_v${PV}.zip -> ${P}.zip"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}

src_install() {
	dodir "/usr/bin"
	mv "${S}/upgrade_tool" "${D}/usr/bin/${PN}"
	dodoc "${S}/linux_upgrade_tool_v${PV}_help(Chinese).pdf"
}
