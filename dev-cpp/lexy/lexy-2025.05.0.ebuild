# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A parser combinator library for C++17 and onwards"
HOMEPAGE="https://lexy.foonathan.net"
SRC_URI="https://github.com/foonathan/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="benchmarks doc examples test"

src_configure() {
	local mycmakeargs=(
		-DLEXY_BUILD_BENCHMARKS=$(usex benchmarks)
		-DLEXY_BUILD_EXAMPLES=$(usex examples)
		-DLEXY_BUILD_TESTS=$(usex test)
		-DLEXY_BUILD_DOCS=$(usex doc)
		-DLEXY_BUILD_PACKAGE=OFF
	)

	cmake_src_configure
}
