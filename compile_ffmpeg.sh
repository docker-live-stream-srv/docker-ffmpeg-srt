#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

# Download ffmpeg source
mkdir -p /tmp/ffmpeg
echo "Downloading '$DOWNLOAD_URL' ..."
wget -qO- $DOWNLOAD_URL | tar -xvz -C /tmp/ffmpeg --strip-components=1

# Switch to build dir
cd /tmp/ffmpeg

# Compile ffmpeg
./configure \
  --disable-debug \
  --disable-doc \
  ###
  --disable-shared \
  --enable-static \
  ###
  --enable-pic \
  --enable-small \
  --enable-ffplay \
  ###
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  ###
  --enable-fontconfig \
  --enable-frei0r \
  --enable-pthreads \
  --enable-runtime-cpudetect \
  --enable-hardcoded-tables \
  --enable-postproc \
  --enable-avresample \
  --enable-filters  \
  ###
  --enable-openssl \
  --enable-libmp3lame \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  --enable-libopenjpeg \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxvid \
  --enable-libzimg \
  --enable-libvpx \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libopus \
  --enable-libfdk-aac \
  --enable-libass \
  --enable-libfribidi \
  --enable-libwebp \
  --enable-librtmp \
  --enable-libsoxr \
  --enable-libspeex \
  --enable-libvidstab \
  --enable-libvo-amrwbenc \
  --enable-libfreetype \
  --enable-libsrt \
  --enable-libsnappy \
  --pkg-config-flags="--static" \
  --extra-cflags="-I${PREFIX}/include -static" \
  --extra-ldflags="-L${PREFIX}/lib -static" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" \
  || (cat ffbuild/config.log && false)
make && make install && make distclean

# Collect required libraries
mkdir -p $PREFIX/lib-used
(
    ldd $PREFIX/bin/ffmpeg && \
    ldd $PREFIX/bin/ffprobe
) | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -u -v '{}' $PREFIX/lib-used
cp -f $PREFIX/lib-used/* $PREFIX/lib
rm -rf $PREFIX/lib-used