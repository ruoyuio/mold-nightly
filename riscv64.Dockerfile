# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM riscv64/debian:unstable-20231030
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-12 g++-12 cmake && \
  ln -sf /usr/bin/gcc-12 /usr/bin/cc && \
  ln -sf /usr/bin/g++-12 /usr/bin/c++ && \
  rm -rf /var/lib/apt/lists
