###############################
# Build image
###############################
ARG SRT_VERSION=latest
FROM livestreamsrv/srt:${SRT_VERSION} as srt
FROM alpine:3.11 as build

ARG VERSION=4.2.2
ENV FFMPEG_DOWNLOAD_URL=http://ffmpeg.org/releases/ffmpeg-${VERSION}.tar.gz

ENV PREFIX=/opt/ffmpeg
ENV LD_LIBRARY_PATH=${PREFIX}/lib
ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
ENV MAKEFLAGS="-j8"

COPY --from=srt /opt/srt/lib /opt/ffmpeg/lib
COPY --from=srt /opt/srt/include /opt/ffmpeg/include

# FFmpeg build dependencies.
RUN apk add --no-cache \
  bash \
  build-base \
  coreutils \
  wget \
  freetype-dev \
  lame-dev \
  libogg-dev \
  libass \
  libass-dev \
  libvpx-dev \
  libvorbis-dev \
  libwebp-dev \
  libtheora-dev \
  opus-dev \
  openssl-dev \
  rtmpdump-dev \
  x264-dev \
  x265-dev \
  snappy-dev \
  yasm \
  gcc \
  cmake

# Check errors in pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Get fdk-aac from community.
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
  apk add --no-cache fdk-aac-dev

# Download ffmpeg source
RUN mkdir -p /tmp/ffmpeg && \
    wget -qO- $FFMPEG_DOWNLOAD_URL | \
      tar -xvz -C /tmp/ffmpeg --strip-components=1

# Switch to build dir
WORKDIR /tmp/ffmpeg

# Compile ffmpeg
RUN ./configure \
  --disable-debug \
  --disable-doc \
  --enable-static \
  --enable-openssl \
  --enable-version3 \
  --enable-pthreads \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
  --enable-libmp3lame \
  --enable-libx264 \
  --enable-libx265 \
  --enable-filters  \
  --enable-libvpx \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libopus \
  --enable-libfdk-aac \
  --enable-libass \
  --enable-libwebp \
  --enable-librtmp \
  --enable-postproc \
  --enable-avresample \
  --enable-libfreetype \
  --enable-libsrt \
  --enable-runtime-cpudetect \
  --enable-hardcoded-tables \
  --enable-libsnappy \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" \ 
  || (cat ffbuild/config.log && false) && \
  make && make install && make distclean

# Collect required libraries
RUN mkdir -p $PREFIX/lib-used && \
    ( \
      ldd $PREFIX/bin/ffmpeg && \
      ldd $PREFIX/bin/ffprobe \
    ) \
      | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -u -v '{}' $PREFIX/lib-used && \
    cp -f $PREFIX/lib-used/* $PREFIX/lib && \
    rm -rf $PREFIX/lib-used && \
    # Remove duplicate libs that are from musl and openssl packages
    rm -rf $PREFIX/lib/ld-musl* && \
    rm -rf $PREFIX/lib/libcrypto*

###############################
# Release image
###############################
FROM alpine:3.11

ENV PREFIX=/opt/ffmpeg
ENV PATH=$PREFIX/bin:$PATH
ENV LD_LIBRARY_PATH=/lib:$PREFIX/lib

RUN apk add --no-cache \
  bash \
  musl \
  openssl \
  ca-certificates

COPY --from=build /opt/ffmpeg /opt/ffmpeg

CMD ["ffmpeg"]