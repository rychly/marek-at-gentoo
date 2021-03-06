# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A fast and flexible static site generator built in GoLang"
HOMEPAGE="http://gohugo.io https://github.com/spf13/hugo/releases/tag/v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 arm"
SRC_URI="x86? ( https://github.com/spf13/hugo/releases/download/v${PV}/hugo_${PV}_Linux-32bit.tar.gz )
	amd64? ( https://github.com/spf13/hugo/releases/download/v${PV}/hugo_${PV}_Linux-64bit.tar.gz )
	arm? ( https://github.com/spf13/hugo/releases/download/v${PV}/hugo_${PV}_linux-ARM.tar.gz )"

RESTRICT="mirror"

src_compile() {
	local hugo="${WORKDIR}/hugo"
	mkdir man; ${hugo} gen man || die "Cannot generate man pages"
	mkdir doc; ${hugo} gen doc --dir doc || die "Cannot generate Markdown documentation"
	${hugo} gen autocomplete --completionfile=hugo-bash-completion.sh --type=bash || die "Cannot generate a bash autocompletion script"
}

src_install() {
	dobin hugo
	dodoc *.md
	doman man/*.1
	insinto /usr/share/bash-completion/completions
	newins hugo-bash-completion.sh hugo
}
