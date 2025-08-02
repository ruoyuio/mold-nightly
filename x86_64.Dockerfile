# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM mirror.gcr.io/library/debian:stretch@sha256:c5c5200ff1e9c73ffbf188b4a67eb1c91531b644856b4aefe86a58d2f0cb05be
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^deb/d' -e 's/^# deb /deb /g' /etc/apt/sources.list && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends wget file make gcc g++ zlib1g-dev libssl-dev ca-certificates && \
  rm -rf /var/lib/apt/lists

# Build CMake 3.27
RUN mkdir /build && \
  cd /build && \
  wget -O- --progress=dot:mega https://cmake.org/files/v3.27/cmake-3.27.7.tar.gz | tar xzf - --strip-components=1 && \
  ./bootstrap --parallel=$(nproc) && \
  make -j$(nproc) && \
  make install && \
  rm -rf /build

# Build GCC 14
RUN mkdir /build && \
  cd /build && \
  wget -O- --progress=dot:mega https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz | tar xzf - --strip-components=1 && \
  mkdir gmp mpc mpfr && \
  wget -O- --progress=dot:mega https://ftpmirror.gnu.org/gmp/gmp-6.3.0.tar.gz | tar xzf - --strip-components=1 -C gmp && \
  wget -O- --progress=dot:mega https://ftpmirror.gnu.org/mpc/mpc-1.3.1.tar.gz | tar xzf - --strip-components=1 -C mpc && \
  wget -O- --progress=dot:mega https://ftpmirror.gnu.org/mpfr/mpfr-4.2.1.tar.gz | tar xzf - --strip-components=1 -C mpfr && \
  ./configure --prefix=/usr --enable-languages=c,c++ --disable-bootstrap --disable-multilib && \
  make -j$(nproc) && \
  make install && \
  ln -sf /usr/lib64/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
  rm -rf /build

# Build GNU binutils 2.43
RUN mkdir /build && \
  cd /build && \
  wget -O- --progress=dot:mega https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.gz | tar xzf - --strip-components=1 && \
  ./configure --prefix=/usr && \
  make -j$(nproc) && \
  make install && \
  rm -fr /build

# Build Python 3.12.7
RUN mkdir /build && \
  cd /build && \
  wget -O- --progress=dot:mega https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz | tar xzf - --strip-components=1 && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  rm -rf /build

# Build LLVM 20
RUN mkdir /build && \
  cd /build && \
  wget -O- --progress=dot:mega https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-20.1.3.tar.gz | tar xzf - --strip-components=1 && \
  mkdir b && \
  cd b && \
  cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang ../llvm && \
  cmake --build . -j$(nproc) && \
  cmake --install . --strip && \
  rm -rf /build
