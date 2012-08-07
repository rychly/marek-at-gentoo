# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=2

JAVA_PKG_IUSE="source"
inherit subversion java-pkg-2 java-ant-2

DESCRIPTION="Gdatafs is a FUSE implemtation that mount your account at google's picassa web to your filesystem. The filesystem support ful read/write and delete of album and photos."
HOMEPAGE="http://sourceforge.net/projects/gdatafs/"

ESVN_REPO_URI="https://gdatafs.svn.sourceforge.net/svnroot/gdatafs/trunk"
ESVN_PROJECT="gdatafs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND=">=sys-fs/fuse-2.4"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	dev-java/junit:4
	${CDEPEND}"

INSTALLDIR="/opt/${PN}"
EANT_BUILD_XML="build.xml"
EANT_BUILD_TARGET="build"

src_unpack() {
	subversion_fetch
	# shell script
	#sed -e 's#jni/:#${JNI}/#g' -e 's#bin:#${BIN}:#g' -e 's#:lib/#:${LIB}/#g' \
	#	-e "s:\\(#!/bin/sh\\):\\1\nROOTPATH=${INSTALLDIR}\nJNI=\${ROOTPATH}/jni\nBIN=\${ROOTPATH}/bin\nLIB=\${ROOTPATH}/lib:" \
	#	-e 's:^\(java \):exec \1:' \
	#	"${S}/gdatafs" > "${S}/gdatafs-launcher"
	# libs
	#sed -e "s:lib/junit.jar:$(java-config -p junit-4):" \
	#	"${FILESDIR}/${EANT_BUILD_XML}" > "${S}/${EANT_BUILD_XML}"
	cp "${FILESDIR}/${EANT_BUILD_XML}" "${S}"
}

java_prepare() {
	cd "${S}"
	java-pkg_jar-from --virtual --into "${S}/lib" junit-4
	eant -q -f "${EANT_BUILD_XML}" cleanall > /dev/null
}

src_install() {
	java-pkg_newjar gdatafs.jar
	java-pkg_dojar $(grep -o 'lib/[^:]*\.jar' "${S}/gdatafs")
	java-pkg_doso jni/$(uname -m)/*.so
	use source && java-pkg_dosrc src/*
	java-pkg_dolauncher ${PN} \
		--java_args "-Dorg.apache.commons.logging.Log=fuse.logging.FuseLog -Dfuse.logging.level=INFO" \
		--main "org.gdatafs.GDataFuse"
}
