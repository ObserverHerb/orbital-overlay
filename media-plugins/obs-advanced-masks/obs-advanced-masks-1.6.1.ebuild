# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A plugin for OBS designed to expand its masking functionalities."
HOMEPAGE="https://f15y.com"

SRC_URI="https://github.com/FiniteSingularity/obs-advanced-masks/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="qt6 frontend"

COMMON_DEPENDS="
	>=media-video/obs-studio-33.0.0
	qt6? (
		dev-qt/qtbase:6[widgets,xml]
		dev-qt/qtsvg:6
	)
	dev-cpp/nlohmann_json
	net-misc/curl
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
