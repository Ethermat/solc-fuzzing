#!/usr/bin/env bash
set -e

ROOTDIR="$(dirname "$0")/.."
BUILDDIR="${ROOTDIR}/build"

if [[ $# -eq 0 ]]; then
    BUILD_TYPE=Release
else
    BUILD_TYPE="$1"
fi

if [[ "$(git tag --points-at HEAD 2>/dev/null)" == v* ]]; then
	touch "${ROOTDIR}/prerelease.txt"
fi

mkdir -p "${BUILDDIR}"
cd "${BUILDDIR}"

cmake .. -DUSE_CVC4=OFF -DUSE_Z3=OFF -DCMAKE_CXX_FLAGS="-g -fsanitize=address,fuzzer" -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE="$BUILD_TYPE" "${@:2}" 
make -j2

if [[ "${CI}" == "" ]]; then
	echo "Installing ..."
	sudo make install
fi
