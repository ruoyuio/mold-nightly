# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM docker.io/loongarch64/debian:sid
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-14 g++-14 clang-19 cmake && \
  ln -sf /usr/bin/clang-19 /usr/bin/clang && \
  ln -sf /usr/bin/clang++-19 /usr/bin/clang++ && \
  rm -rf /var/lib/apt/lists
