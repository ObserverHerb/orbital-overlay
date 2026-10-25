# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A collection of OBS filters to give your stream that retro feel."
HOMEPAGE="https://f15y.com"

SRC_URI="https://github.com/FiniteSingularity/obs-retro-effects/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="qt6 frontend"

COMMON_DEPENDS="
	>=media-video/obs-studio-33.0.0
	qt6? (
		dev-qt/qtbase:6[widgets]
	)
"
DEPEND="${COMMON_DEPENDS}"
RDEPEND="${COMMON_DEPENDS}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT=$(usex qt6)
		-DENABLE_FRONTEND_API=$(usex frontend)
	)

	cmake_src_configure
}
