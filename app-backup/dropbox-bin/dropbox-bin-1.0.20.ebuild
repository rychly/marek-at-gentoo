# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
inherit eutils python

DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/${PN/bin/lnx}.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/${PN/bin/lnx}.x86_64-${PV}.tar.gz )
	scripts? ( http://dl.dropbox.com/u/552/pyDropboxPath/1.0.1/pyDropboxPath.py
		http://dl.dropbox.com/u/340607/pyDropboxValues.py )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+scripts debug"
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.14"
DEPEND="${RDEPEND}"
#	dev-python/docutils
#	dev-util/pkgconfig"

DOCS="ACKNOWLEDGEMENTS VERSION"

pkg_setup() {
	enewgroup dropbox
	enewuser dropbox -1 -1 /opt/${PN} dropbox
}

src_prepare() {
	mv .dropbox-dist "${P}"
	# exec-bit for executables only
	find "${P}" -type f -print0 | xargs -0 chmod 644
	chmod 755 "${P}/dropbox" "${P}/dropboxd"
	# remove shipped libstdc++.so.6 as it does not provide LIBCXX_3.4.11
	# and it seems to work alright with the one from >=gcc-4
	rm "${S}/libstdc++.so.6" || die "rm libstdc++.so.6 failed"
}

src_install() {
	# Blame the craptastic software
	dodir "/opt/${PN}"
	mv "${S}" "${D}/opt/${PN}/bin" || die

	if use scripts; then
		dodir "/opt/${PN}/scripts"
		cp --no-preserve=links "${DISTDIR}/pyDropboxPath.py" "${DISTDIR}/pyDropboxValues.py" "${D}/opt/${PN}/scripts" || die
		fperms a+x "/opt/${PN}/scripts/pyDropboxPath.py" "/opt/${PN}/scripts/pyDropboxValues.py"
	fi

	exeinto /opt/bin
	doexe "${FILESDIR}/dropboxd"

	newconfd "${FILESDIR}/dropboxd.confd" dropboxd
	newinitd "${FILESDIR}/dropboxd.initd" dropboxd

	fowners -R dropbox:dropbox "/opt/${PN}" || die
	fperms o-rwx "/opt/${PN}" || die

	fowners dropbox:dropbox /opt/bin/dropboxd || die
	fperms o-rwx /opt/bin/dropboxd || die
}

pkg_postinst() {
	ewarn
	ewarn "You still need to create a .dropbox configuration folder after"
	ewarn "the installation.  Install this package on a computer with a "
	ewarn "GUI and run /opt/bin/dropboxd.  Follow the instructions and "
	ewarn "just leave the dropbox folder location where it defaults to."

	elog
	elog "If you've installed this manually, Remove ~/.dropbox-dist now."
	elog
	elog "You should start the daemon automatically:"
	elog "\tetc-update add dropboxd default"
	elog
}
