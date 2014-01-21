# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit rpm mount-boot

VERMAJ="${PV%.*.*.*}"
VERMIN="${PV#*.*.*.}"
MYVERSION="${VERMAJ}-${VERMIN}.el6uek"
LINUX_DIRNAME="linux-${MYVERSION}"
if use debug; then
	MYARCH="x86_64.debug"
else
	MYARCH="x86_64"
fi

DESCRIPTION="Full Linux kernel sources - The Unbreakable Enterprise Kernel Release 3 (UEK R3) by Oracle"
HOMEPAGE="https://oss.oracle.com/ol6/docs/RELEASE-NOTES-UEK3-en.html"
SRC_URI_PREFIX="http://public-yum.oracle.com/repo/OracleLinux/OL6/UEKR3/latest/x86_64/getPackage"
SRC_URI="${SRC_URI_PREFIX}Source/kernel-uek-${MYVERSION}.src.rpm
	binary? (
		 debug? ( ${SRC_URI_PREFIX}/kernel-uek-debug-${MYVERSION}.x86_64.rpm )
		!debug? ( ${SRC_URI_PREFIX}/kernel-uek-${MYVERSION}.x86_64.rpm )
		${SRC_URI_PREFIX}/kernel-uek-firmware-${MYVERSION}.noarch.rpm
	)"

KEYWORDS="amd64"
SLOT="${VERMAJ}-${VERMIN}"
RESTRICT="binchecks strip mirror"
LICENSE="GPL-2"
IUSE="binary debug symlink"

DEPEND=""
RDEPEND="binary? ( >=sys-fs/udev-147 )"

src_prepare() {
	## module symlink fixup
	if use binary; then
		rm "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}/build"
		ln -s "/usr/src/${LINUX_DIRNAME}" "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}/build"
	fi
	## set default kernel config
	local config_from
	if use debug; then
		config_from="${WORKDIR}/config-x86_64-debug"
	else
		config_from="${WORKDIR}/config-x86_64"
	fi
	local config_to="${WORKDIR}/linux-${VERMAJ}/.config"
	#local config_to="${WORKDIR}/linux-${VERMAJ}/arch/x86/configs/x86_64_defconfig"
	cp "${config_from}" "${config_to}" || die "Unable to set default kernel config"
}

src_install() {
	## move kernel sources into place
	dodir /usr/src
	mv "${WORKDIR}/linux-${VERMAJ}" "${D}/usr/src/${LINUX_DIRNAME}" || die "Unable to install kernel sources"
	## move binaries
	if use binary; then
		# move boot
		dodir /boot
		mv "${WORKDIR}/boot"/{System.map,config,symvers}* "${D}/boot" || die "Unable to install kernel symbols/config"
		mv "${WORKDIR}/boot/vmlinuz-${MYVERSION}.${MYARCH}" "${D}/boot/kernel-${MYVERSION}.${MYARCH}" || die "Unable to install kernel bzImage"
		chmod 644 "${D}/boot/kernel-${MYVERSION}.${MYARCH}"
		# move and strip modules
		dodir /lib64/modules
		mv "${WORKDIR}/lib/modules"/* "${D}/lib64/modules/" || die "Unable to install modules"
		find "${D}/lib64/modules" -iname *.ko -exec strip --strip-debug {} \;
		# move firmware
		dodir /lib64/firmware
		mv "${WORKDIR}/lib/firmware"/* "${D}/lib64/firmware/" || die "Unable to install firmware"
		dodoc "${WORKDIR}/usr/share/doc/kernel-uek-firmware-${VERMAJ}/WHENCE"
		# move LD config
		dodir /etc/ld.so.conf.d
		mv "${WORKDIR}/etc/ld.so.conf.d"/* "${D}/etc/ld.so.conf.d/" || die "Unable to install LD config"
		# fixes FL-14
		cp "${D}/boot/config-${MYVERSION}.${MYARCH}" "${D}/usr/src/${LINUX_DIRNAME}/.config" || die "Unable to copy kernel config"
		cp "${D}/boot/System.map-${MYVERSION}.${MYARCH}" "${D}/usr/src/${LINUX_DIRNAME}/System.map" || die "Unable to copy System.map"
		gzip -dc "${D}/boot/symvers-${MYVERSION}.${MYARCH}.gz" > "${D}/usr/src/${LINUX_DIRNAME}/Module.symvers" || die "Unable to copy Module.symvers"
	fi
}

pkg_post_inst() {
	## src/linux symlink
	if use symlink; then
		ln -sf "${LINUX_DIRNAME}" "${ROOT}/usr/src/linux"
	fi
}
