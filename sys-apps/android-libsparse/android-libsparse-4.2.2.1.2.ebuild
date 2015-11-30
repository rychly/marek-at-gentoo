# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PV_MAJ="${PV:0:5}" PV_REL=${PV:6} MY_PV="${PV_MAJ%.0}_r${PV_REL}"

DESCRIPTION="Library and tools for Android sparse image format."
HOMEPAGE="https://android.googlesource.com/platform/system/core/+/master/libsparse/"
SRC_URI="https://android.googlesource.com/platform/system/core/+archive/android-${MY_PV}/libsparse.tar.gz -> core-android-${MY_PV}-libsparse.tar.gz"

LICENSE="Apache-2.0"
SLOT="${MY_PV}"
KEYWORDS="x86 amd64"
IUSE="static"
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
	# build static library
	for I in ${libsparse_src_files}; do
		gcc -c -o "${I%.c}.o" -Iinclude "${I}" \
			${CFLAGS} ${LDLAGS} \
			|| die "Cannot compile ${I}!"
	done
	ar rcs "libsparse-${PV}.a" ${libsparse_src_files//.c/.o} \
		${ARFLAGS} \
		|| die "Cannot make a static library!"
	# build shared library
	for I in ${libsparse_src_files}; do
		gcc -fPIC -c -o "${I%.c}.o" -Iinclude "${I}" \
			${CFLAGS} ${LDLAGS} \
			|| die "Cannot compile ${I}!"
	done
	gcc -shared "-Wl,-soname,libsparse.so.${PV}" -o "libsparse.so.${PV}" -lz ${libsparse_src_files//.c/.o} \
		${CFLAGS} ${LDLAGS} \
		|| die "Cannot make a shared library!"
	# build host executables linked against the shared/static library
	local local_src_files
	sed -n '/CLEAR_VARS/,/BUILD_HOST_EXECUTABLE/{/CLEAR_VARS/{h;d};H;/BUILD_HOST_EXECUTABLE/{x;p}}' Makefile \
	| grep 'LOCAL_SRC_FILES' | cut -d '=' -f 2- \
	| while read local_src_files; do
		local outfile="${local_src_files%%.c*}"
		if use static; then
			gcc -o "${outfile}-${MY_PV}" -Iinclude -lz ${local_src_files} "libsparse-${PV}.a" \
				${CFLAGS} ${LDLAGS} \
				|| die "Cannot compile ${local_src_files}!"
		else
			gcc -o "${outfile}-${MY_PV}" -Iinclude -L. "-l:libsparse.so.${PV}" ${local_src_files} \
				${CFLAGS} ${LDLAGS} \
				|| die "Cannot compile ${local_src_files}!"
		fi
	done
}

src_install() {
	insinto "/usr/include/sparse-${PV}"
	doins "include/sparse/sparse.h"
	dolib "libsparse-${PV}.a" "libsparse.so.${PV}"
	dobin "simg2img-${MY_PV}" "img2simg-${MY_PV}" "simg2simg-${MY_PV}"
}
