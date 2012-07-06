# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Advanced/Another Bisimulation Checker is a tool that checks open-equivalence in the pi-calculus."
HOMEPAGE="http://lamp.epfl.ch/~sbriais/abc/"
SRC_URI="http://lamp.epfl.ch/~sbriais/abc/${PN}.tar.gz
	doc? ( http://lamp.epfl.ch/~sbriais/abc/abc_ug.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +ocamlopt"
RESTRICT="nomirror"

DEPEND=">=dev-lang/ocaml-3.06"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_setup() {
	use ocamlopt && if ! built_with_use --missing true 'dev-lang/ocaml' ocamlopt; then
		eerror "In order to build ${PN} with your useflags you first need to build 'dev-lang/ocaml' with 'ocamlopt' useflag"
		die "Please install 'dev-lang/ocaml' with 'ocamlopt' useflag"
	fi
}

src_compile() {
	if use ocamlopt; then
		emake -j1 opt || die "Error: make to build native code failed!"
	else
		emake -j1 || die "Error: make to build OCaml bytecode failed!"
	fi
}

src_install() {
	use ocamlopt && mv -v "${S}/${PN}.opt" "${S}/${PN}"
	dobin "${S}/${PN}" || die "Cannot install executable"
	dodoc "${S}/README" "${S}/LICENSE" || die "Cannot install documentation"
	if use examples; then
		dodir "/usr/share/doc/${P}" \
		&& mv "${S}/examples" "${D}/usr/share/doc/${P}" \
		|| die "Cannot install examples"
	fi
	use doc && dodoc "${DISTDIR}/abc_ug.pdf" || die "Cannot install documentation"
}