# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils subversion

IUSE="nls xinerama truetype kde gnome imlib disableslit disabletoolbar"

DESCRIPTION="Fluxbox is an X11 window manager featuring tabs and an iconbar"
HOMEPAGE="http://www.fluxbox.org"

ESVN_REPO_URI="svn://svn.berlios.de/fluxbox/trunk"
ESVN_MODULE="fluxbox"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

# Please note that USE="kde gnome" simply adds support for the respective
# protocols, and does not depend on external libraries. They do, however,
# make the binary a fair bit bigger, so we don't want to turn them on unless
# the user actually wants them.

RDEPEND="|| ( ( x11-libs/libXpm
			x11-libs/libXrandr
			xinerama? ( x11-libs/libXinerama )
			x11-apps/xmessage
		)
		virtual/x11
	)
	virtual/xft
	truetype? ( media-libs/freetype )
	imlib? ( >=media-libs/imlib2-1.2.0 )
	!<x11-themes/fluxbox-styles-fluxmod-20040809-r1"
DEPEND="!<=x11-misc/fluxconf-0.9.9
		>=sys-devel/autoconf-2.52
		nls? ( sys-devel/gettext )
		|| ( ( x11-proto/xextproto
				xinerama? ( x11-proto/xineramaproto )
			)
			virtual/x11
		)
		${RDEPEND}"
PROVIDE="virtual/blackbox"

SLOT="0"
LICENSE="MIT"
KEYWORDS=""

pkg_setup() {
	if use imlib ; then
		if ! built_with_use media-libs/imlib2 X ; then
			eerror "To build fluxbox with imlib in USE, you need an X enabled"
			eerror "media-libs/imlib2 . Either recompile imlib2 with the X"
			eerror "USE flag turned on or disable the imlib USE flag for fluxbox."
			die "USE=imlib requires imlib2 with USE=X"
		fi
	fi
}

src_unpack() {
	subversion_fetch
	cd "${S}"

	# We need to be able to include directories rather than just plain
	# files in menu [include] items. This patch will allow us to do clever
	# things with style ebuilds.
	epatch "${FILESDIR}/our-styles-go-over-here.patch" ||	die "Patch failed"

	# Add in the Gentoo -r number to fluxbox -version output.
	suffix="gentoo"
	sed -i \
		-e "s~\(__fluxbox_version .@VERSION@\)~\1-${suffix}~" \
		version.h.in || die "version sed failed"

	# Turn on aa by default if possible. Fluxbox fonts are really frickin'
	# broken, we'll do what we can to make it less painful by default.
	use truetype 1>/dev/null && \
		echo "session.screen0.antialias: true" >> data/init.in

	# Fix broken styles
	ebegin "Fixing backgrounds..."
	for style in "${S}/data/styles/"* ; do
		[[ -f "${style}" ]] || continue
		sed -i -e 's,\([^f]\)bsetroot,\1fbsetroot,' "${style}" \
			|| die "styles sed failed on ${style}"
	done
	eend 0

	subversion_bootstrap
}

src_compile() {
	export PKG_CONFIG_PATH=/usr/X11R6/lib/pkgconfig:/usr/lib/pkgconfig

	econf \
		$(use_enable nls) \
		$(use_enable xinerama) \
		$(use_enable truetype xft) \
		$(use_enable kde) \
		$(use_enable gnome) \
		$(use_enable imlib imlib2) \
		$(use_enable !disableslit slit ) \
		$(use_enable !disabletoolbar toolbar ) \
		--sysconfdir=/etc/X11/${PN} \
		--with-style=/usr/share/fluxbox/styles/Emerge \
		${myconf} || die "configure failed"

	emake || die "make failed"

	ebegin "Creating a menu file (may take a while)"
	mkdir -p "${T}/home/.fluxbox" || die "mkdir home failed"
	MENUFILENAME="${S}/data/menu" MENUTITLE="Fluxbox ${PV}" \
		CHECKINIT="no. go away." HOME="${T}/home" \
		"${S}/util/fluxbox-generate_menu" -is -ds \
		|| die "menu generation failed"
	eend $?
}

src_install() {
	dodir /usr/share/fluxbox
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README* AUTHORS TODO* ChangeLog NEWS

	dodir /usr/share/xsessions
	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	dodir /etc/X11/Sessions
	echo "/usr/bin/startfluxbox" > "${D}/etc/X11/Sessions/fluxbox"
	fperms a+x /etc/X11/Sessions/fluxbox

	dodir /usr/share/fluxbox/menu.d

	# Styles menu framework
	dodir /usr/share/fluxbox/menu.d/styles
	insinto /usr/share/fluxbox/menu.d/styles
	doins "${FILESDIR}/styles-menu-fluxbox" || die
	doins "${FILESDIR}/styles-menu-commonbox" || die
	doins "${FILESDIR}/styles-menu-user" || die
}

