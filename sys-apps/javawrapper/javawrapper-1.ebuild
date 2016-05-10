# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="The wrapper for binfmt_misc/java and the utility to find the correct class name from a Java *.class file."
HOMEPAGE="http://www.linux-france.org/article/linuxman/199907/199907.html#19990730"
SRC_URI="http://www.linux-france.org/article/linuxman/199907/javawrapper
	http://www.linux-france.org/article/linuxman/199907/javaclassname.c"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror"

src_unpack() {
	cp ${DISTDIR}/javawrapper ${WORKDIR}/${PN} || die "Cannot copy the script file!"
}

src_compile() {
	gcc ${DISTDIR}/javaclassname.c -o ${WORKDIR}/javaclassname || die 'Cannot compile the source file!'
}

src_install() {
	dobin "javaclassname" "${PN}" || die "Unable to install executable script and binary!"
}
