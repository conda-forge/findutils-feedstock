#!/bin/bash

autoreconf -fiv
./configure --prefix="$PREFIX" --disable-dependency-tracking
make -j${CPU_COUNT}

# Disabling historical strftime tests
sed -i.bak -e '120,126 s@.*/\* ! \*/@@' tests/test-strftime.c

# Ensure tests are executable
chmod +x find/testsuite/{sv-48030-exec-plus-bug.sh,sv-48180-refuse-noop.sh}

# Make mktemp commands osx compatible
sed -i.bak -e 's@mktemp -d@mktemp -d \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/sv-34079.sh
sed -i.bak -e 's@mktemp -d@mktemp -d \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/sv-34976-execdir-fd-leak.sh
sed -i.bak -e 's@mktemp -d@mktemp -d \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/sv-48030-exec-plus-bug.sh
sed -i.bak -e 's@mktemp -d@mktemp -d \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/sv-48180-refuse-noop.sh
sed -i.bak -e 's@mktemp -d@mktemp -d \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/sv-bug-32043.sh

sed -i.bak -e 's@mktemp@mktemp \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/test_escapechars.sh
sed -i.bak -e 's@mktemp@mktemp \${TMPDIR:-/tmp}/tmp.XXXXXXXXXX@' find/testsuite/test_inode.sh

if [[ ! $target_platform =~ osx ]]; then
  make check -j${CPU_COUNT}
fi
make install
