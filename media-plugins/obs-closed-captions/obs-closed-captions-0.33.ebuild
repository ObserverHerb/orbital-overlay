# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Closed Captioning OBS plugin using Google Speech Recognition"
HOMEPAGE="https://github.com/ratwithacompiler/OBS-captions-plugin"
SRC_URI="https://github.com/ratwithacompiler/OBS-captions-plugin/archive/v${PV}.tar.gz"
S="${WORKDIR}/OBS-captions-plugin-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-debug"

DEPEND="
	dev-qt/qtbase:6[widgets]
	sys-libs/plibsys
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
    "${FILESDIR}/package-manager-compliance.patch"
)

src_configure() {
	local mycmakeargs=(
		-DUSE_DEVMODE=$(usex debug)
		-DENABLE_CUSTOM_API_KEY=ON
	)

	cmake_src_configure
}
