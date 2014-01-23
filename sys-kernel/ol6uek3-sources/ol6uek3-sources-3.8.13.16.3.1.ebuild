# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit rpm eutils mount-boot

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
SLOT="${PV}"
RESTRICT="binchecks strip mirror"
LICENSE="GPL-2"
IUSE="binary debug symlink lvm mdadm cryptsetup iscsi"

DEPEND="binary? (
		>=sys-kernel/genkernel-3.4.40.1
		mdadm? ( sys-fs/mdadm[static] )
		cryptsetup? ( sys-fs/cryptsetup[static] )
	)"
#	binary? ( lvm? ( sys-fs/lvm2[static] ) ) ## disabled in /usr/share/genkernel/gen_initramfs.sh:append_lvm()
RDEPEND="sys-libs/libdtrace-ctf
	binary? ( >=sys-fs/udev-147 )"

S="${WORKDIR}/linux-${VERMAJ}"

src_prepare() {
	if use binary; then
		## module and firmware symlinks fixup
		rm "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}/build"
		ln -s "/usr/src/${LINUX_DIRNAME}" "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}/build"
		mv "${WORKDIR}/lib/firmware/${MYVERSION}" "${WORKDIR}/lib/firmware/${MYVERSION}.${MYARCH}"
		ln -s "${MYVERSION}.${MYARCH}" "${WORKDIR}/lib/firmware/${MYVERSION}"
		## fixes FL-14
		cp "${WORKDIR}/boot/System.map-${MYVERSION}.${MYARCH}" "${S}/System.map" || die "Unable to copy System.map"
		gzip -dc "${WORKDIR}/boot/symvers-${MYVERSION}.${MYARCH}.gz" > "${S}/Module.symvers" || die "Unable to copy Module.symvers"
		cp "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}"/modules.{builtin,order} "${S}/" || die "Unable to copy modules lists"
		## set default kernel config
		cp "${WORKDIR}/boot/config-${MYVERSION}.${MYARCH}" "${S}/.config" || die "Unable to copy kernel config"
	else
		## set default kernel config
		local config_from
		if use debug; then
			config_from="${WORKDIR}/config-x86_64-debug"
		else
			config_from="${WORKDIR}/config-x86_64"
		fi
		local config_to="${S}/.config"
		#local config_to="${S}/arch/x86/configs/x86_64_defconfig"
		cp "${config_from}" "${config_to}" || die "Unable to set default kernel config"
	fi
	## set kernel's extra version to match $(uname -r), necessary for genkernel's $KV and building of modules
	## this setting cannot be done by CONFIG_LOCALVERSION as the binary kernel's config is different
	sed -i "s/^\\(EXTRAVERSION =\\).*\$/\\1 -${VERMIN}.el6uek.${MYARCH}/" "${S}/Makefile"
}

src_compile() {
	if use binary; then
		## rebuild modules.dep
		depmod -b "${WORKDIR}" -E "${S}/Module.symvers" "${MYVERSION}.${MYARCH}" -F "${S}/System.map" || die "Unable to rebuild modules.dep"
		## create initramfs
		install -d "${T}"/{cache,twork,bin}
		cp "${FILESDIR}/lvm-strip-fix.sh" "${T}/bin/strip"
		chmod 755 "${T}/bin"/*
		PATH="${T}/bin:${PATH}" genkernel \
			--makeopts="${MAKEOPTS}" \
			--kerneldir="${S}" \
			--kernel-config="${S}/.config" \
			--module-prefix="${WORKDIR}" \
			--firmware-dir="${WORKDIR}/lib/firmware" \
			--bootdir="${WORKDIR}/boot" \
			--cachedir="${T}/cache" --tempdir="${T}/twork" --logfile="${T}/genkernel.log" \
			--no-save-config --no-install \
			$(usex lvm "--lvm" "--no-lvm") \
			$(usex mdadm "--mdadm" "--no-mdadm") \
			$(usex cryptsetup "--luks" "--no-luks") \
			$(usex iscsi "--iscsi" "--no-iscsi") \
			initramfs || die "Unable to build initramfs"
		mv "${T}/twork"/initramfs-* "${WORKDIR}/boot/" || die "Unable to copy initramfs"
		## prepare kernel for building external kernel modules
		unset ARCH LDFLAGS # will interfere with kernel's Makefile if set
		make -C "${S}" modules_prepare || die "Unable to prepare kernel for building external modules"
	fi
}

src_install() {
	## move kernel sources into place
	dodir /usr/src
	mv "${S}" "${D}/usr/src/${LINUX_DIRNAME}" || die "Unable to install kernel sources"
	## move binaries
	if use binary; then
		# move boot
		dodir /boot
		mv "${WORKDIR}/boot"/{System.map,config,symvers,initramfs}-* "${D}/boot" || die "Unable to install kernel symbols/config/initramfs"
		mv "${WORKDIR}/boot/vmlinuz-${MYVERSION}.${MYARCH}" "${D}/boot/kernel-${MYVERSION}.${MYARCH}" || die "Unable to install kernel bzImage"
		chmod a-x "${D}/boot/kernel-${MYVERSION}.${MYARCH}"
		# move firmware
		dodir /lib64/firmware
		mv "${WORKDIR}/lib/firmware"/* "${D}/lib64/firmware/" || die "Unable to install firmware"
		dodoc "${WORKDIR}/usr/share/doc/kernel-uek-firmware-${VERMAJ}/WHENCE"
		# move LD config
		dodir /etc/ld.so.conf.d
		mv "${WORKDIR}/etc/ld.so.conf.d"/* "${D}/etc/ld.so.conf.d/" || die "Unable to install LD config"
		# modules will be moved after the install to beware to be added into @module-rebuild, now justr strip them
		find "${WORKDIR}/lib64/modules" -iname *.ko -exec strip --strip-debug {} \;
	fi
}

pkg_postinst() {
	if use binary; then
		## move and strip kernel modules
		einfo "Merging kernel modules..."
		mkdir -vp /lib64/modules
		cp -vrf "${WORKDIR}/lib/modules/${MYVERSION}.${MYARCH}" "/lib64/modules/" || die "Unable to install modules"
		einfo "... kernel modules have been merged"
	fi
	if use symlink; then
		## src/linux symlink
		einfo "Creating symlinks to the kernel..."
		[[ -h "${ROOT}usr/src/linux" ]] && rm "${ROOT}usr/src/linux"
		ln -vsf "${LINUX_DIRNAME}" "${ROOT}usr/src/linux"
		## boot/* symlinks
		if use binary; then
			local symlinkkernel="/boot/kernel"
			local symlinkinitramfs="/boot/initramfs"
			local symlinksystemmap="/boot/System.map"
			for symlink in "${symlinkkernel}" "${symlinkinitramfs}" "${symlinksystemmap}"; do
				## backup if not already backuped
				[[ -h "${symlink}" ]] && [[ "$(readlink ${symlink})" != "$(readlink ${symlink}.old)" ]] && mv -vf "${symlink}" "${symlink}.old"
				## if does not exists or exists symlink (not common file), create the new symlink to current kernel etc.
				[[ -h "${symlink}" ]] || ! [[ -e "${symlink}" ]] && ln -vsf "$(basename ${symlink})-${MYVERSION}.${MYARCH}" "${symlink}"
			done
		fi
		einfo "... symlinks have been created"
	fi
	echo
	elog "If you are upgrading from a previous kernel, you may be interested"
	elog "in the following document:"
	elog "  - General upgrade guide: http://www.gentoo.org/doc/en/kernel-upgrade.xml"
	echo
}
