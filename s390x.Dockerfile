# Copyright (c) 2023 Rui Ueyama. Licensed under the MIT License.
# https://github.com/rui314/mold/blob/main/LICENSE

FROM debian:bullseye-20231030@sha256:96fb9ce5d3ce7f3dab7c34c18edfee093904cbc7fc19162dbcca22b2cc273b9d
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN sed -i -e '/^deb/d' -e 's/^# deb /deb [trusted=yes] /g' /etc/apt/sources.list && \
  echo 'Acquire::Retries "10"; Acquire::http::timeout "10"; Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80-retries && \
  apt-get update && \
  apt-get install -y --no-install-recommends build-essential gcc-10 g++-10 cmake && \
  ln -sf /usr/bin/gcc-10 /usr/bin/cc && \
  ln -sf /usr/bin/g++-10 /usr/bin/c++ && \
  rm -rf /var/lib/apt/lists
