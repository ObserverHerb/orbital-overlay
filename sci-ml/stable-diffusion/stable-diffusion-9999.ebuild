# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( 20 21 22 23 )

inherit cmake git-r3 llvm-r1 systemd

DESCRIPTION="Diffusion model(SD,Flux,Wan,Qwen Image,Z-Image,...) inference in pure C/C++"

EGIT_REPO_URI="https://github.com/leejet/${PN}.cpp.git"
EGIT_SUBMODULES=( '*' )
KEYWORDS="~amd64"
PROPERTIES="live"

LICENSE="MIT"
SLOT="0"
IUSE="debug video_cards_amdgpu"

BDEPEND="
	video_cards_amdgpu? (
		dev-util/rocminfo
		dev-libs/rocm-comgr
		dev-libs/rocr-runtime
		dev-libs/rocm-core
		dev-libs/rocm-device-libs
		dev-libs/roct-thunk-interface
		dev-build/rocm-cmake
		sci-libs/rocBLAS
		sci-libs/hipBLAS
		sci-libs/hipBLAS-common
		dev-util/Tensile
	)
	dev-util/hip
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
		llvm-core/lld-toolchain-symlinks:${LLVM_SLOT}
		llvm-core/llvm-toolchain-symlinks:${LLVM_SLOT}
		llvm-core/llvmgold
		llvm-core/clang-common
		llvm-runtimes/clang-runtime:${LLVM_SLOT}
		llvm-core/clang-toolchain-symlinks:${LLVM_SLOT}
		llvm-runtimes/compiler-rt:${LLVM_SLOT}
		llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}
		llvm-runtimes/openmp:${LLVM_SLOT}
		llvm-core/clang-linker-config:${LLVM_SLOT}
		llvm-runtimes/clang-rtlib-config:${LLVM_SLOT}
		llvm-runtimes/clang-unwindlib-config:${LLVM_SLOT}
		llvm-runtimes/clang-stdlib-config:${LLVM_SLOT}
	')
"

COMMON_DEPENDS=""
DEPEND="${COMMON_DEPENDS}"
RDEPEND="${COMMON_DEPENDS}"

pkg_setup() {
	llvm-r1_pkg_setup
}

llvm_check_deps() {
	if ! has_version -b "llvm-core/clang:${LLVM_SLOT}"; then
		einfo "llvm-core/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi
	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

src_prepare() {
	default

	local ggml_submodule_directory="${S}/ggml"
	if [[ -d "${ggml_submodule_directory}" ]]; then
		einfo "Patching ggml"

		pushd "${ggml_submodule_directory}" > /dev/null || die
		eapply "${FILESDIR}/ggml-explicit-type.patch"
		popd > /dev/null || die
	else
		die "ggml submodule directory not found!"
	fi

	eapply_user

	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE=$(usex debug Debug Release)

	local mycmakeargs=(
		-DSD_HIPBLAS=$(usex video_cards_amdgpu)
		-DGPU_TARGETS="${AMDGPU_TARGETS}"
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DSD_BIN_INSTALL_DIR=/usr/bin
		-DSD_LIB_INSTALL_DIR=$(get_libdir)
	)

	cmake_src_configure
}

src_install() {
	default

	systemd_dounit "${FILESDIR}/${PN}.service"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	cmake_src_install
}
