# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A 3D physics engine for games"
HOMEPAGE="https://box2d.org"
SRC_URI="https://github.com/erincatto/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="benchmarks docs +double-precision -sanitize +simd test validate"

src_configure() {
	local mycmakeargs=(
		-DBOX3D_SANITIZE=$(usex sanitize)
		-DBOX3D_DISABLE_SIMD=$(usex !simd)
		-DBOX3D_DOUBLE_PRECISION=$(usex double-precision)
		-DBOX3D_SAMPLES=OFF # uses FetchContent, which Portage doesn't allow
		-DBOX3D_BENCHMARKS=$(usex benchmarks)
		-DBOX3D_DOCS=$(usex docs)
		-DBOX3D_PROFILE=OFF
		-DBOX3D_VALIDATE=$(usex validate)
		-DBOX3D_UNIT_TESTS=$(usex test)
		-DBOX3D_BUILD_SHADERS=OFF
	)

	cmake_src_configure
}
