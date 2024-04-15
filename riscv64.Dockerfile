# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM riscv64/debian:sid-20240311@sha256:8c02dbe4faa999b588e873cc1759dd9b340f39daf4d7aabdb2c1a87cdc586459
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^URIs/d' -e 's/^# http/URIs: http/' /etc/apt/sources.list.d/debian.sources && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-12 g++-12 cmake && \
  ln -sf /usr/bin/gcc-12 /usr/bin/cc && \
  ln -sf /usr/bin/g++-12 /usr/bin/c++ && \
  rm -rf /var/lib/apt/lists
