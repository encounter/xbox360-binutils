#!/bin/bash -ex
PREFIX="$(pwd)/build"
mkdir source
wget -qO- https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.xz | tar -xJ -C source --strip-components=1
cd source
for patch in ../*.patch; do
  patch -N -p1 -i "$patch"
done
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.11"
./configure --target=powerpc-xenon-pe --prefix="$PREFIX" --disable-nls --disable-shared --disable-gprof --without-zstd
make -j$(nproc) configure-host
make -j$(nproc)
make install-strip
