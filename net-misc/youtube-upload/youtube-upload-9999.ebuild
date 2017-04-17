# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=(python{2_7,3_4,3_5})
inherit distutils-r1 eutils git-r3

DESCRIPTION="Upload videos to Youtube from the command line."
HOMEPAGE="https://github.com/tokland/youtube-upload"
EGIT_REPO_URI="https://github.com/tokland/youtube-upload.git"

LICENSE="gpl-3"
SLOT="0"
KEYWORDS=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/google-api-python-client
	|| ( dev-python/progressbar  dev-python/progressbar2 )"
