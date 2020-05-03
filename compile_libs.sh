#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

LIBS_BUILD_DIR="${PREFIX}/libs-build"

LIB_OPENSSL_VERSION="1.1.1g"
LIB_MP3_LAME_VERSION="3.100"
LIB_OPEN_JPEG_VERSION="2.3.1"
LIB_ZIMG_VERSION="2.9.3"
LIB_VPX_VERSION="1.8.2"
LIB_VORBIS_VERSION="1.3.6"
LIB_OPUS_VERSION="1.3.1"
LIB_FDK_ACC_VERSION="2.0.1"
LIB_ASS_VERSION="0.14.0"
LIB_FRIBIDI_VERSION="1.0.9"

build "openssl"  "https://www.openssl.org/source/openssl-${LIB_OPENSSL_VERSION}.tar.gz"
build "lame"     "https://downloads.sourceforge.net/project/lame/lame/${LIB_MP3_LAME_VERSION}/lame-${LIB_MP3_LAME_VERSION}.tar.gz"
build "openjpeg" "https://github.com/uclouvain/openjpeg/archive/v${LIB_OPEN_JPEG_VERSION}.tar.gz"
build "x264"     "https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz"
build "x265"     "https://bitbucket.org/multicoreware/x265/get/stable.tar.gz"
build "zimg"     "https://github.com/sekrit-twc/zimg/archive/release-${LIB_ZIMG_VERSION}.tar.gz"
build "vpx"      "https://github.com/webmproject/libvpx/archive/v${LIB_VPX_VERSION}.tar.gz"
build "vorbis"   "https://github.com/xiph/vorbis/archive/v${LIB_VORBIS_VERSION}.tar.gz"
build "opus"     "https://github.com/xiph/opus/archive/v${LIB_OPUS_VERSION}.tar.gz"
build "fdk-acc"  "https://github.com/mstorsjo/fdk-aac/archive/v${LIB_FDK_ACC_VERSION}.tar.gz"
build "ass"      "https://github.com/libass/libass/archive/${LIB_ASS_VERSION}.tar.gz"
build "fribidi"  "https://github.com/fribidi/fribidi/archive/v${LIB_FRIBIDI_VERSION}.tar.gz"