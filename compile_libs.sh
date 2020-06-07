#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

source ./compile_common.sh

LIB_OPENSSL_VERSION="1.1.1g"
LIB_MP3_LAME_VERSION="3.100"
LIB_OPEN_JPEG_VERSION="2.3.1"
LIB_ZIMG_VERSION="2.9.3"
LIB_VPX_VERSION="1.8.2"
LIB_OGG_VERSION="1.3.4"
LIB_VORBIS_VERSION="1.3.6"
LIB_OPUS_VERSION="1.3.1"
LIB_FDK_ACC_VERSION="2.0.1"
LIB_FREETYPE_VERSION="2.10.1"
LIB_FRIBIDI_VERSION="1.0.9"
LIB_HARFBUZZ_VERSION="2.6.4"
LIB_ASS_VERSION="0.14.0"
LIB_WEBP_VERSION="1.1.0"
LIB_SOXR_VERSION="0.1.3"
LIB_SPEEX_VERSION="1.2.0"
LIB_VIDSTAB_VERSION="1.1.0"
LIB_SNAPPY_VERSION="1.1.8"
LIB_FREI0R_VERSION="1.7.0"
LIB_RTMP_MODIFIED_VERSION="master"
LIB_SRT_VERSION='1.4.1'
LIB_VORBIS_VERSION="1.3.3"
LIB_PNG_MAIN_VERSION="libpng15"
LIB_PNG_VERSION="1.5.30"
LIB_THEORA_VERSION="1.1.1"
LIB_VO_AMRWBENC_VERSION="0.1.3"
LIB_XVID_VERSION="1.3.7"

# OpenSSL
build   "openssl"  "https://www.openssl.org/source/openssl-${LIB_OPENSSL_VERSION}.tar.gz" \
        './config -static --prefix="$PREFIX" && make && make install'

# Mp3 Lame
build   "lame"     "https://downloads.sourceforge.net/project/lame/lame/${LIB_MP3_LAME_VERSION}/lame-${LIB_MP3_LAME_VERSION}.tar.gz" \
        './configure --prefix="$PREFIX" --enable-nasm --disable-shared && make && make install'

# OpenJpeg
build   "openjpeg" "https://github.com/uclouvain/openjpeg/archive/v${LIB_OPEN_JPEG_VERSION}.tar.gz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DBUILD_SHARED_LIBS:bool=off && make && make install'

# x264
build   "x264"     "https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz" \
        './configure --prefix="$PREFIX" --enable-static --disable-shared --disable-opencl --enable-pic && make && make install'

# x265
build   "x265"     "https://bitbucket.org/multicoreware/x265/get/stable.tar.gz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ./source && sed -i "s/-lgcc_s/-lgcc_eh/g" x265.pc && make && make install'

# zimg
build   "zimg"     "https://github.com/sekrit-twc/zimg/archive/release-${LIB_ZIMG_VERSION}.tar.gz" \
        './autogen.sh && ./configure --enable-static  --prefix="$PREFIX" --disable-shared && make && make install'

# vpx
build   "vpx"      "https://github.com/webmproject/libvpx/archive/v${LIB_VPX_VERSION}.tar.gz" \
        './configure --prefix="$PREFIX" --disable-examples --disable-unit-tests --enable-pic && make && make install'

# ogg - vorbis deps
build   "ogg"      "https://github.com/xiph/ogg/archive/v${LIB_OGG_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# vorbis
build   "vorbis"   "https://github.com/xiph/vorbis/archive/v${LIB_VORBIS_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# opus
build   "opus"     "https://github.com/xiph/opus/archive/v${LIB_OPUS_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# fdk-aac
build   "fdk-aac"  "https://github.com/mstorsjo/fdk-aac/archive/v${LIB_FDK_ACC_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# freetype - libass dep
build   "freetype" "https://download.savannah.gnu.org/releases/freetype/freetype-${LIB_FREETYPE_VERSION}.tar.xz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared --without-harfbuzz && make && make install'

# fribidi - libass dep
build   "fribidi"  "https://github.com/fribidi/fribidi/archive/v${LIB_FRIBIDI_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared --enable-static --disable-docs && MAKEFLAGS="-j1" make && make install'

# harfbuzz - libass dep
build   "harfbuzz" "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${LIB_HARFBUZZ_VERSION}.tar.xz" \
        './configure --prefix="$PREFIX" --disable-shared --enable-static && make && make install'

# ass
build   "ass"      "https://github.com/libass/libass/archive/${LIB_ASS_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# webp
build   "webp"     "https://github.com/webmproject/libwebp/archive/v${LIB_WEBP_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# soxr
build   "soxr"     "https://downloads.sourceforge.net/project/soxr/soxr-${LIB_SOXR_VERSION}-Source.tar.xz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off && make && make install'

# speex
build   "speex"    "https://github.com/xiph/speex/archive/Speex-${LIB_SPEEX_VERSION}.tar.gz" \
        './autogen.sh && ./configure --prefix="$PREFIX" --disable-shared && make && make install'

# vidstab
build   "vidstab"  "https://github.com/georgmartius/vid.stab/archive/v${LIB_VIDSTAB_VERSION}.tar.gz" \
        'sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt && \
         cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DENABLE_C_DEPS=ON -DBUILD_SHARED_LIBS:bool=off && \
         make && make install
        '

# snappy
build   "snappy"   "https://github.com/google/snappy/archive/${LIB_SNAPPY_VERSION}.tar.gz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DBUILD_SHARED_LIBS:bool=off && make && make install'

# frei0r
build   "frei0r"     "https://github.com/dyne/frei0r/archive/v${LIB_FREI0R_VERSION}.tar.gz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DBUILD_SHARED_LIBS:bool=off && make && make install'

# rtmp
build   "rtmp"     "https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1/archive/${LIB_RTMP_MODIFIED_VERSION}.tar.gz" \
        "cd librtmp && \
         sed -i '/INC=.*/d' ./Makefile && \
         sed -i 's/prefix=.*/prefix=${PREFIX_SED}\nINC=-I\$(prefix)\/include/' ./Makefile && \
         sed -i 's/SHARED=.*/SHARED=no/' ./Makefile && \
         make && make install
        "

# srt
build   "srt"     "https://github.com/Haivision/srt/archive/v${LIB_SRT_VERSION}.tar.gz" \
        'cmake . -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$PREFIX" -DENABLE_C_DEPS=ON -DENABLE_SHARED=OFF -DENABLE_STATIC=ON -DENABLE_APPS=OFF && make && make install'

# png - theora dep
build   "png" "https://downloads.sourceforge.net/project/libpng/${LIB_PNG_MAIN_VERSION}/${LIB_PNG_VERSION}/libpng-${LIB_PNG_VERSION}.tar.gz" \
        './configure --prefix="$PREFIX" --disable-shared --enable-static --disable-docs && make && make install'

# theora
build   "theora" "http://downloads.xiph.org/releases/theora/libtheora-${LIB_THEORA_VERSION}.tar.bz2" \
        './configure --prefix="$PREFIX" --disable-shared --enable-static && make && make install'

# vo-amrwbenc
build   "vo-amrwbenc" "https://downloads.sourceforge.net/project/opencore-amr/vo-amrwbenc/vo-amrwbenc-${LIB_VO_AMRWBENC_VERSION}.tar.gz" \
        './configure --prefix="$PREFIX" --disable-shared --enable-static && make && make install'

# xvid
build   "xvid" "https://downloads.xvid.com/downloads/xvidcore-${LIB_XVID_VERSION}.tar.gz " \
        'cd build/generic && ./configure --prefix="$PREFIX" --disable-shared --enable-static && make && make install'