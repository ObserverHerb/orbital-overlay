# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A comprehensive blur plugin for OBS that provides several different blur algorithms, and proper compositing."
HOMEPAGE="https://saprykin.github.io/plibsys-docs/"

SRC_URI="https://github.com/saprykin/plibsys/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE="test static-libs gcov +visibility +doc"

COMMON_DEPENDS="
	doc? ( app-text/doxygen )
"
DEPEND="${COMMON_DEPENDS}"
RDEPEND="${COMMON_DEPENDS}"

src_configure() {
	local mycmakeargs=(
		-DPLIBSYS_TESTS=$(usex test)
		-DPLIBSYS_BUILD_STATIC=$(usex static-libs)
		-DPLIBSYS_BUILD_STATIC=$(usex gcov)
		-DPLIBSYS_VISIBILITY=$(usex visibility)
		-DPLIBSYS_BUILD_DOC=$(usex doc)
	)

	cmake_src_configure
}
