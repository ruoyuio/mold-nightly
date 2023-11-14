# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM debian:jessie-20210326
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^deb/d' -e 's/^# //g' /etc/apt/sources.list && \
  echo 'Acquire { Retries "10"; http::timeout "10"; Check-Valid-Until "false"; };' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --force-yes --no-install-recommends wget bzip2 file make autoconf gcc g++ libssl-dev && \
  rm -rf /var/lib/apt/lists

# Build CMake 3.27
RUN mkdir -p /build/cmake && \
  cd /build/cmake && \
  wget -O- --no-check-certificate https://cmake.org/files/v3.27/cmake-3.27.7.tar.gz | tar xzf - --strip-components=1 && \
  ./bootstrap --parallel=$(nproc) && \
  make -j$(nproc) && \
  make install && \
  rm -rf /build

# Build GCC 10
RUN mkdir -p /build/gcc && \
  cd /build/gcc && \
  wget -O- http://ftp.gnu.org/gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.gz | tar xzf - --strip-components=1 && \
  mkdir isl gmp mpc mpfr && \
  wget -O- http://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2 | tar xjf - --strip-components=1 -C isl && \
  wget -O- http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2 | tar xjf - --strip-components=1 -C gmp && \
  wget -O- http://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz | tar xzf - --strip-components=1 -C mpc && \
  wget -O- http://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.gz | tar xzf - --strip-components=1 -C mpfr && \
  ./configure --prefix=/usr --enable-languages=c,c++ --disable-bootstrap --disable-multilib && \
  make -j$(nproc) && \
  make install && \
  ln -sf /usr/lib64/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
  rm -rf /build
