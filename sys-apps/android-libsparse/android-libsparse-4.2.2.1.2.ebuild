# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PV_MAJ="${PV:0:5}" PV_REL=${PV:6} MY_PV="${PV_MAJ%.0}_r${PV_REL}"

DESCRIPTION="???"
HOMEPAGE="https://android.googlesource.com/platform/system/core/+/master/libsparse/"
SRC_URI="https://android.googlesource.com/platform/system/core/+archive/android-${MY_PV}/libsparse.tar.gz -> core-android-${MY_PV}-libsparse.tar.gz"

LICENSE="Apache-2.0"
SLOT="${MY_PV}"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	cat Android.mk | tr '\n' '!' | sed -s 's/\\!\s*//g' | tr '!' '\n' >Makefile
}

src_compile() {
	# get library source files
	local libsparse_src_files=$(grep '^libsparse_src_files' Makefile | cut -d '=' -f 2-)
	# build host executables
	local local_src_files
	sed -n '/CLEAR_VARS/,/BUILD_HOST_EXECUTABLE/{/CLEAR_VARS/{h;d};H;/BUILD_HOST_EXECUTABLE/{x;p}}' Makefile \
	| grep 'LOCAL_SRC_FILES' | cut -d '=' -f 2- \
	| while read local_src_files; do
		gcc -o "${local_src_files%%.c*}-${MY_PV}" -Iinclude -lz \
			$(echo ${local_src_files} ${libsparse_src_files} | tr ' ' '\n' | sort | uniq | tr '\n' ' ') \
			${CFLAGS} ${LDLAGS}
	done
}

src_install() {
	dobin "simg2img-${MY_PV}" "img2simg-${MY_PV}" "simg2simg-${MY_PV}"
}
