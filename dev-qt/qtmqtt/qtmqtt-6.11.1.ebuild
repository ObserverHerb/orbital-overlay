# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Standard compliant Qt implementation of the MQTT protocol"
SRC_URI="https://www.engineeringdeck.com/distfiles/qtmqtt-everywhere-src-${PV}.tar.xz"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

IUSE="qml"

DEPEND="
	qml? ( =dev-qt/qtdeclarative-${PV}* )
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro

	qt6-build_src_prepare
}
