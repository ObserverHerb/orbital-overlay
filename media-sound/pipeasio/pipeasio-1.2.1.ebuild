# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Low-latency audio driver that connects Wine applications straight to PipeWire"
SRC_URI="https://github.com/M0n7y5/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +gui wow64"

RDEPEND="
	gui? ( dev-qt/qtbase:6[widgets] )
	media-video/pipewire[sound-server(+)]
	wow64? (
		|| (
			app-emulation/wine-vanilla[wow64]
			app-emulation/wine-staging[wow64]
			app-emulation/wine-proton[wow64]
		)
	)
	!wow64? ( virtual/wine )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WOW64_32=$(usex wow64)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_SETTINGS_PANEL=$(usex gui "ON" "OFF")
	)

	cmake_src_configure
}
