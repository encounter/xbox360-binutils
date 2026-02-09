#!/bin/bash -ex
PREFIX="$(pwd)/build"
mkdir source
wget -qO- https://mirrors.ibiblio.org/gnu/binutils/binutils-2.45.1.tar.xz | tar -xJ -C source --strip-components=1
cd source
for patch in ../*.patch; do
  patch -N -p1 -i "$patch"
done
export CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=10.11"
./configure --target=powerpc-xenon-pe --prefix="$PREFIX" --disable-nls --disable-shared --disable-gprof --disable-ld --disable-gold --without-zstd --with-system-zlib
make -j$(nproc) configure-host
# Touch .info files after configure so they're newer than generated .texi files
find . -name '*.info' -exec touch {} +
make -j$(nproc)
make install-strip
