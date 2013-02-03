# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm systemd

IUSE="hardened"

MY_PV="${PV%.*.*}-${PV#*.*.*.}"
MY_MV="${PV%%.*}"
MY_PM="${PN}-${MY_MV}"

DESCRIPTION="Oracle 11g Express Edition for Linux"
HOMEPAGE="http://www.oracle.com/technetwork/products/express-edition/overview/index.html"
SRC_URI="http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-${MY_PV}.x86_64.rpm.zip"

LICENSE="OTN"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="fetch binchecks"

S="${WORKDIR}"

RDEPEND="dev-libs/libaio
	!dev-db/oracle-instantclient-basic
	!dev-db/oracle-instantclient-jdbc
	!dev-db/oracle-instantclient-sqlplus"

DEPEND="${RDEPEND}"

pkg_nofetch() {
	eerror
	eerror "Please go to"
	eerror "  ${HOMEPAGE}"
	eerror "and download the ${DESCRIPTION} package:"
	eerror "  ${SRC_URI}"
	eerror "into"
	eerror "  ${DISTDIR}"
	eerror
}

INSTALL_BASE="/u01/app/oracle"
INSTALL_DIR="${INSTALL_BASE}/product/11.2.0/xe"
ORACLE_BASE="/opt/${MY_PM}"
ORACLE_HOME="${ORACLE_BASE}/xe"
ORACLE_USER="oracle"
ORACLE_GROUP="dba"
MEMORY_TARGET="0"

pkg_setup() {
	# prepare environment for further configuration
	enewgroup "${ORACLE_GROUP}"
	enewuser "${ORACLE_USER}" -1 -1 "${ORACLE_BASE}" "${ORACLE_GROUP}"
}

src_unpack() {
	unpack "${A}"
	cd "${WORKDIR}/Disk1"
	rpm_unpack "./$(basename ${A} .zip)"
	rm "./$(basename ${A} .zip)"
	# patch directories
	for I in \
	"./${INSTALL_DIR}/bin"/oracle_env.* \
	"./${INSTALL_DIR}/config/scripts"/* \
	"./${INSTALL_DIR}/network/admin/listener.ora"; \
	do
		sed -i \
		-e "s:${INSTALL_DIR}:${ORACLE_HOME}:g" \
		-e "s:${INSTALL_BASE}:${ORACLE_BASE}:g" \
		${I}
	done
	# patch libraries
	sed -i 's:^\(-.*\)$:\1 -lrt:' "./${INSTALL_DIR}/lib/sysliblist"
	ln -s "libagtsh.so.1.0" "./${INSTALL_DIR}/lib/libagtsh.so"
}

src_install() {
	# main
	dodir "${ORACLE_HOME}"
	mv "${WORKDIR}/Disk1${INSTALL_DIR}"/* "${D}${ORACLE_HOME}"
	chmod 755 "${D}${ORACLE_HOME}/config/scripts"/*.sh
	# desktop
	dodir "/usr/share/applications"
	for I in "${WORKDIR}/Disk1/usr/share/applications"/*.desktop; do
		sed \
			-e "s/oraclexe-/oraclexe-11-/g" \
			-e "s:${INSTALL_DIR}:${ORACLE_HOME}:g" \
			"${I}" > "${D}/usr/share/applications/$(basename ${I/oraclexe-/oraclexe-11-})"
	done
	sed -i '/MimeType=Application\/database/d' "${D}/usr/share/applications/oraclexe-11-startdb.desktop"
	dodir "/usr/share/desktop-menu-files"
	for I in "${WORKDIR}/Disk1/usr/share/desktop-menu-files"/*.directory; do
		sed \
			-e "s/oraclexe-/oraclexe-11-/g" \
			"${I}" > "${D}/usr/share/desktop-menu-files/$(basename ${I/oraclexe-/oraclexe-11-})"
	done
	dodir "/usr/share/gnome/vfolders"
	for I in "${WORKDIR}/Disk1/usr/share/gnome/vfolders"/*.directory; do
		sed \
			-e "s/oraclexe-/oraclexe-11-/g" \
			"${I}" > "${D}/usr/share/gnome/vfolders/$(basename ${I/oraclexe-/oraclexe-11-})"
	done
	dodir "/usr/share/pixmaps"
	for I in "${WORKDIR}/Disk1/usr/share/pixmaps"/*.png; do
		mv "${I}" "${D}/usr/share/pixmaps/$(basename ${I/oraclexe-/oraclexe-11-})"
	done
	# doc
	dodoc "${WORKDIR}/Disk1/usr/share/doc/oracle_xe"/*
	# config scripts
	insinto "/usr/share/${P}"
	doins "${WORKDIR}/Disk1/response/xe.rsp" "${WORKDIR}/Disk1/upgrade/gen_inst.sql" "${WORKDIR}/Disk1/etc/init.d/oracle-xe"
	sed -i \
		-e "s:${INSTALL_DIR}:${ORACLE_HOME}:g" \
		-e "s:${INSTALL_BASE}:${ORACLE_BASE}:g" \
		-e "s:CONFIG_NAME=oracle-xe:CONFIG_NAME=${MY_PM}:g" \
		"${D}/usr/share/${P}/oracle-xe" "${D}${ORACLE_HOME}/config/scripts/oracle-xe"
		#-e "s:/etc/default:/etc/conf.d:g" \ removed for it is not conf.d file
	fperms 755 "/usr/share/${P}/oracle-xe" "${ORACLE_HOME}/config/scripts/oracle-xe"
	# prevent revdep-rebuild from attempting to rebuild all the time
	dodir "/etc/revdep-rebuild"
	echo "SEARCH_DIRS_MASK=\"${ORACLE_HOME}\"" > "${D}/etc/revdep-rebuild/50${MY_PM}"
	# prepare environment for further configuration
	dodir "${ORACLE_BASE}/oradata"
	dodir "${ORACLE_BASE}/diag"
	dodir "${ORACLE_BASE}/oradiag_oracle"
	dodir "${ORACLE_HOME}/log" "${ORACLE_HOME}/config/log" "${ORACLE_HOME}/rdbms/log"
	fowners "${ORACLE_USER}:${ORACLE_GROUP}" \
		"${ORACLE_BASE}/oradata" \
		"${ORACLE_BASE}/diag" \
		"${ORACLE_BASE}/oradiag_oracle" \
		"${ORACLE_HOME}/log" "${ORACLE_HOME}/config/log" "${ORACLE_HOME}/rdbms/log" \
		"${ORACLE_HOME}/dbs"
	# fix parameter file and create basic directories (the rest will be created by ${ORACLE_HOME}/config/scripts/XE.sh during config)
	sed "s:<ORACLE_BASE>:${ORACLE_BASE}:g" "${D}${ORACLE_HOME}/dbs/init.ora" > "${D}${ORACLE_HOME}/dbs/initXE.ora"
	dodir "${ORACLE_BASE}/admin/orcl/adump"
	dodir "${ORACLE_BASE}/flash_recovery_area"
	dodir "${ORACLE_BASE}/fast_recovery_area"
	fowners "${ORACLE_USER}:${ORACLE_GROUP}" \
		"${ORACLE_BASE}/admin" "${ORACLE_BASE}/admin/orcl" "${ORACLE_BASE}/admin/orcl/adump" \
		"${ORACLE_BASE}/flash_recovery_area" \
		"${ORACLE_BASE}/fast_recovery_area"
	# do substitutions
	sed -i \
		"s:%memory_target%:${MEMORY_TARGET}:g" \
		"${D}${ORACLE_HOME}/config/scripts/init.ora" "${D}${ORACLE_HOME}/config/scripts/initXETemp.ora"
	sed -i \
		"s:%ORACLE_HOME%:${ORACLE_HOME}:g" \
		"${D}${ORACLE_HOME}/config/scripts/postScripts.sql"
	# permissions and ownership set above are not sufficient, give the whole basedir to orauser
	chown -R "${ORACLE_USER}:${ORACLE_GROUP}" "${D}${ORACLE_HOME}"
	# environment variables
	dodir "/etc/env.d"
	cat > "${D}/etc/env.d/50${MY_PM}" <<END
ORACLE_BASE=${ORACLE_BASE}
ORACLE_HOME=${ORACLE_HOME}
ORACLE_OWNER=${ORACLE_USER}
ORACLE_SID=XE
ORACLE_UNQNAME=orcl
ORA_NLS10=${ORACLE_HOME}/nls/data
NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
PATH=${ORACLE_HOME}/bin
ROOTPATH=${ORACLE_HOME}/bin
LDPATH=${ORACLE_HOME}/lib
END
	# init scripts and units
	newinitd "${FILESDIR}/${MY_PM}.initd" "${MY_PM}"
	systemd_dounit "${FILESDIR}/${MY_PM}-listener.service" "${FILESDIR}/${MY_PM}-database.service"
}

pkg_config() {
	# check kernel config
	einfo
	einfo "Checking kernel parameters, set in /etc/sysctl.d/60-oracle.conf"
	local filemax=$(cat /proc/sys/fs/file-max)
	local iplocalportrange1=$(cat /proc/sys/net/ipv4/ip_local_port_range | cut -d $'\t' -f 1)
	local iplocalportrange2=$(cat /proc/sys/net/ipv4/ip_local_port_range | cut -d $'\t' -f 2)
	local sem1=$(cat /proc/sys/kernel/sem | cut -d $'\t' -f 1)
	local sem2=$(cat /proc/sys/kernel/sem | cut -d $'\t' -f 2)
	local sem3=$(cat /proc/sys/kernel/sem | cut -d $'\t' -f 3)
	local sem4=$(cat /proc/sys/kernel/sem | cut -d $'\t' -f 4)
	local shmmax=$(cat /proc/sys/kernel/shmmax)
	if [ ${filemax} -lt 6815744 ]; then
		eerror "  fs.file-max=6815744"
		change=yes
	fi
	if [ ${iplocalportrange1} -gt 9000 -o ${iplocalportrange2} -lt 65500 ]; then
		eerror "  net.ipv4.ip_local_port_range=9000 65500"
		change=yes
	fi
	if [ ${sem1} -lt 250 -o ${sem2} -lt 32000 -o ${sem3} -lt 100 -o ${sem4} -lt 128 ]; then
		eerror "  kernel.sem=250 32000 100 128"
		change=yes
	fi
	if [ ${shmmax} -lt 107374183 ]; then
		eerror "  kernel.shmmax=107374183"
		change=yes
	fi
	if [ -n "${change}" ]; then
		eerror "... set the parameters and try again"
		eerror
		die "wrong kernel parameters"
	else
		einfo "... all OK"
		einfo
	fi
	# check /dev/shm size (${MEMORY_TARGET}=0 means disabled AMM and no need for /dev/shm)
	local shmsize=$(df /dev/shm | tail -1 | sed 's:\s\{1,\}: :g' | cut -d ' ' -f 2)
	if [ ${MEMORY_TARGET} -gt 0 -a ${shmsize} -lt 2097152 ]; then
		eerror
		eerror "Mountpoint /dev/shm must be at least 2097152 kB, add into the following into /etc/fstab and remount"
		eerror "  shmfs /dev/shm tmpfs defaults,nosuid,nodev,noexec,relatime,size=2097152k 0 0"
		eerror
		die "small /dev/shm"
	fi
	# check oracle temp
	if [ -e "/var/tmp/.oracle" ]; then
		eerror
		eerror "Stop eventual Oracle Net Listener (${ORACLE_HOME}/bin/lsnrctl stop) and run"
		eerror "  rm -rf /var/tmp/.oracle /var/lock/subsys/listener"
		eerror
		die "existing '/var/tmp/.oracle'"
	fi
	# run configure
	sh -c "/usr/share/${P}/oracle-xe configure"
	echo "CONFIGURE_RUN=true" > "/etc/conf.d/oracle-xe-bin-11"
}

pkg_postinst() {
	# info
	einfo
	einfo "The ${DESCRIPTION} has been installed."
	einfo
	elog "You might want to run:"
	elog "  emerge --config =${P}"
	elog "if this is a new install."
	einfo
	einfo "If you use the database in UTF-8 with Forms6i you should change"
	einfo "its character set from 'AL32UTF8' to 'UTF8'. Please run:"
	einfo "  su -s /bin/bash -c '${ORACLE_HOME}/bin/sqlplus / as sysdba' oracle"
	einfo "and run the following SQL script:"
	einfo "  SHUTDOWN IMMEDIATE;"
	einfo "  STARTUP MOUNT;"
	einfo "  ALTER SYSTEM ENABLE RESTRICTED SESSION;"
	einfo "  ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;"
	einfo "  ALTER SYSTEM SET AQ_TM_PROCESSES=0;"
	einfo "  ALTER DATABASE OPEN;"
	einfo "  ALTER DATABASE CHARACTER SET INTERNAL_USE UTF8;"
	einfo "  SHUTDOWN;"
	einfo "  STARTUP RESTRICT;"
	einfo "  SHUTDOWN;"
	einfo "  STARTUP;"
	einfo
	einfo "To enable web-base administration interface, run:"
	einfo "  su -s /bin/bash -c 'echo \"EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);\" | ${ORACLE_HOME}/bin/sqlplus / as sysdba' oracle"
	einfo "and then access the following web-pages (with the port in accordance to the configuration):"
	einfo "  http://localhost:8080/apex/apex_admin"
	einfo "  http://localhost:8080/apex"
	einfo
}
