# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A closed-source RockChip's firmware images (*.img) unpacker/packer."
HOMEPAGE="http://forum.xda-developers.com/showthread.php?t=2257331"
SRC_URI="http://forum.xda-developers.com/attachment.php?attachmentid=3434522&d=1439217533 -> ${P}.zip"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}"

src_install() {
	dobin imgrepackerrk || die 'cannot install binary'
}
