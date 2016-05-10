# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Advanced/Another Bisimulation Checker is a tool that checks open-equivalence in the pi-calculus."
HOMEPAGE="http://sbriais.free.fr/tools/abc/"
# the unversioned download, patch level set to Last-Modified as it has been get by curl -I <URI>
SRC_URI="http://sbriais.free.fr/tools/abc/${PN}.tar.gz -> ${P}.tgz
	doc? ( http://sbriais.free.fr/tools/abc/abc_ug.pdf -> ${PN}_ug-${PV}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +ocamlopt"
RESTRICT="nomirror"

DEPEND=">=dev-lang/ocaml-3.06[ocamlopt?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

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
	use doc && dodoc "${DISTDIR}/${PN}_ug-${PV}.pdf" || die "Cannot install documentation"
}
