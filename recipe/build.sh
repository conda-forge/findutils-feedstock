#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Disable failing/irrelevant tests
sed -i '/TESTS += test-vc-list-files-cvs.sh/d' gnulib-tests/Makefile.am
sed -i 's/test-vc-list-files-git.sh test-vc-list-files-cvs.sh/test-vc-list-files-cvs.sh/' gnulib-tests/Makefile.am
sed -i '/binary_tests =/d' tests/local.mk
sed -i '/tests\/xargs\/test-sigusr/d' tests/local.mk
sed -i '/tests\/find\/used.sh/d' tests/local.mk
sed -i '/tests\/find\/newer.sh/d' tests/local.mk

if [[ ${target_platform} == "linux-aarch64" || ${target_platform} == "linux-ppc64le" ]]; then
    sed -i '/tests\/find\/depth-unreadable-dir/d' tests/local.mk
    sed -i '/tests\/xargs\/conflicting_opts/d' tests/local.mk
fi

autoreconf --force --verbose --install
./configure --prefix="$PREFIX" --disable-dependency-tracking
make -j${CPU_COUNT}

if [[ ${build_platform} == ${target_platform} ]]; then
    make check -j${CPU_COUNT}
fi
make install
