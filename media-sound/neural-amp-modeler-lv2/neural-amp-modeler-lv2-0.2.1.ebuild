# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LV2 plugin for neural network machine learning amp model playback using the NeuralAudio engine"

NEURAL_AUDIO_VERSION="0.1.1"
MATH_APPROX_VERSION="1.0.0"
RTNEURAL_HASH="5909c44909cd6100367f62cd04b348de85d57dbf"
NAM_CORE_HASH="4c0ee78b71abd5eb20aec58562e7540f43caac3b"
SRC_URI="
	https://github.com/mikeoliphant/${PN}/archive/refs/tags/v${PV}.tar.gz
	https://github.com/mikeoliphant/NeuralAudio/archive/refs/tags/v${NEURAL_AUDIO_VERSION}.tar.gz -> ${PN}-NeuralAudio-${NEURAL_AUDIO_VERSION}.tar.gz
	https://github.com/Chowdhury-DSP/math_approx/archive/refs/tags/v${MATH_APPROX_VERSION}.tar.gz -> ${PN}-math_approx-${MATH_APPROX_VERSION}.tar.gz
	https://github.com/mikeoliphant/RTNeural/archive/${RTNEURAL_HASH}.tar.gz -> ${PN}-RTNeural-${RTNEURAL_HASH}.tar.gz
	https://github.com/mikeoliphant/NeuralAmpModelerCore/archive/${NAM_CORE_HASH}.tar.gz -> ${PN}-NAMCore-${NAM_CORE_HASH}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="smart-bypass +namcore +inline-gemm +a2-fast -static-rtneural -static-wavenet -static-lstm +fastmath eigenmath stdmath test"
REQUIRED_USE="^^ ( fastmath eigenmath stdmath )"

BDEPEND="media-libs/lv2"
DEPEND="media-libs/lv2"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if use static-rtneural; then
		ewarn "Warning: Only use 'static-rtneural' if you plan on forcing RTNeural model loading"
	fi

	if use static-rtneural || use static-wavenet || use static-lstm; then
		ewarn "Static architectures result in faster processing but slower compilation and largers binary sizes"
	fi
}

src_unpack() {
	default

	rmdir "${S}/deps/NeuralAudio" || die
	mv "${WORKDIR}/NeuralAudio-${NEURAL_AUDIO_VERSION}" "${S}/deps/NeuralAudio"

	rmdir "${S}/deps/NeuralAudio/deps/math_approx" || die
	mv "${WORKDIR}/math_approx-${MATH_APPROX_VERSION}" "${S}/deps/NeuralAudio/deps/math_approx"

	rmdir "${S}/deps/NeuralAudio/deps/RTNeural" || die
	mv "${WORKDIR}/RTNeural-${RTNEURAL_HASH}" "${S}/deps/NeuralAudio/deps/RTNeural"

	rmdir "${S}/deps/NeuralAudio/deps/NeuralAmpModelerCore" || die
	mv "${WORKDIR}/NeuralAmpModelerCore-${NAM_CORE_HASH}" "${S}/deps/NeuralAudio/deps/NeuralAmpModelerCore"
}

src_configure() {
	local math_approximation_choice="FastMath"
	if use eigenmath; then
		math_approximation_choice="EigenMath"
	elif use stdmath; then
		math_approximation_choice="StdMath"
	fi

	local mycmakeargs=(
		-DUSE_NATIVE_ARCH=OFF # sets -march that will conflict with make.conf
		-DSMART_BYPASS_ENABLED=$(usex smart-bypass)
		-DBUILD_NAMCORE=$(usex namcore)
		-DNAM_USE_INLINE_GEMM=$(usex inline-gemm)
		-DNAM_ENABLE_A2_FAST=$(usex a2-fast)
		-DBUILD_STATIC_RTNEURAL=$(usex static-rtneural)
		-DBUILD_INTERNAL_STATIC_WAVENET=$(usex static-wavenet)
		-DBUILD_INTERNAL_STATIC_LSTM=$(usex static-lstm)
		-DDEFAULT_QUALITY_SCALE="1.0"
		-DDEFAULT_INPUT_DBU="12"
		-DWAVENET_FRAMES=64
		-DBUFFER_PADDING=24
		-DWAVENET_MATH=${math_approximation_choice}
		-DLSTM_MATH=${math_approximation_choice}
		-DBUILD_UTILS=$(usex test)
	)

	cmake_src_configure
}
