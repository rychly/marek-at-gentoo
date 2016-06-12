# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Rockchip tools for update.img, parameter, bootloader and other partitions"
HOMEPAGE="http://wiki.radxa.com/Rock/flash_the_image#Upgrade_tool_from_Rockchip"
SRC_URI="http://dl.radxa.com/rock/tools/linux/Linux_Upgrade_Tool_v${PV}.zip -> ${P}.zip"

LICENSE="proprietary-unspecified"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/Linux_Upgrade_Tool_v${PV}"

src_install() {
	dodir "/usr/bin"
	mv "${S}/upgrade_tool" "${D}/usr/bin/${PN}" || die 'cannot install binary'
}
