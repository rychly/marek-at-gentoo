# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PV_MAJ="${PV:0:5}" PV_REL=${PV:6} MY_PV="${PV_MAJ%.0}_r${PV_REL}"

DESCRIPTION="Library and tools for Android ext2/3/4 images."
HOMEPAGE="https://android.googlesource.com/platform/system/extras/+/master/ext4_utils/"
SRC_URI="https://android.googlesource.com/platform/system/extras/+archive/android-${MY_PV}/ext4_utils.tar.gz -> extras-android-${MY_PV}-ext4_utils.tar.gz"

LICENSE="Apache-2.0"
SLOT="${MY_PV}"
KEYWORDS="x86 amd64"
IUSE="static"
RESTRICT="mirror"

S="${WORKDIR}"

RDEPEND="sys-libs/zlib
	=sys-apps/android-libsparse-${PV}"
DEPEND="${RDEPEND}"

src_prepare() {
	cat Android.mk | tr '\n' '!' | sed -s 's/\\!\s*//g' | tr '!' '\n' >Makefile
	sed -i "s|\(#include <sparse\)/|\1-${PV}/|g" *.c
	sed -e "s/mkuserimg/mkuserimg-${MY_PV}/g" -e "s/make_ext4fs/make_ext4fs-${MY_PV}/g" mkuserimg.sh > "mkuserimg-${MY_PV}"
}

src_compile() {
	# get library source files
	local libext4_utils_src_files=$(grep '^libext4_utils_src_files' Makefile | cut -d '=' -f 2-)
	# build static library
	for I in ${libext4_utils_src_files}; do
		gcc -c -o "${I%.c}.o" "${I}" \
			${CFLAGS} ${LDLAGS} \
			|| die "Cannot compile ${I}!"
	done
	ar rcs "libext4_utils-${PV}.a" ${libext4_utils_src_files//.c/.o} \
		${ARFLAGS} \
		|| die "Cannot make a static library!"
	# build shared library
	for I in ${libext4_utils_src_files}; do
		gcc -fPIC -c -o "${I%.c}.o" "${I}" \
			${CFLAGS} ${LDLAGS} \
			|| die "Cannot compile ${I}!"
	done
	gcc -shared "-Wl,-soname,libext4_utils.so.${PV}" -o "libext4_utils.so.${PV}" -lz "-l:libsparse.so.${PV}" ${libext4_utils_src_files//.c/.o} \
		${CFLAGS} ${LDLAGS} \
		|| die "Cannot make a shared library!"
	# build host executables linked against the shared/static library
	local local_src_files
	sed -n '/CLEAR_VARS/,/BUILD_HOST_EXECUTABLE/{/CLEAR_VARS/{h;d};H;/BUILD_HOST_EXECUTABLE/{x;p}}' Makefile \
	| grep 'LOCAL_SRC_FILES' | cut -d '=' -f 2- \
	| while read local_src_files; do
		local outfile="${local_src_files%%.c*}"
		if use static; then
			gcc -o "${outfile%_main}-${MY_PV}" ${local_src_files} -lz "/usr/lib/libsparse-${PV}.a" "libext4_utils-${PV}.a" \
				${CFLAGS} ${LDLAGS} \
				|| die "Cannot compile ${local_src_files}!"
		else
			gcc -o "${outfile%_main}-${MY_PV}" -L. "-l:libsparse.so.${PV}" "-l:libext4_utils.so.${PV}" ${local_src_files} \
				${CFLAGS} ${LDLAGS} \
				|| die "Cannot compile ${local_src_files}!"
		fi
	done
}

src_install() {
	insinto "/usr/include/ext4_utils-${PV}"
	doins "ext4_utils.h"
	dolib "libext4_utils-${PV}.a" "libext4_utils.so.${PV}"
	dobin "mkuserimg-${MY_PV}" "ext2simg-${MY_PV}" "ext4fixup-${MY_PV}" "make_ext4fs-${MY_PV}"
}
