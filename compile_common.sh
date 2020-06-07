LIBS_BUILD_DIR="${PREFIX}/libs-build"
PREFIX_SED=$(echo "$PREFIX" | awk '{gsub(/\//, "\\/"); print}')
export LD_LIBRARY_PATH=${PREFIX}/lib
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export MAKEFLAGS="-j$(nproc)"

# Build target, first argument
BUILD_TARGET="${1:-all}"

getWorkdir() {
    name="$1"
    url="$2"
    url_hash=`echo -n "${url}"| md5sum | awk '{print $1}' | cut -c1-8`
    workdir="${LIBS_BUILD_DIR}/${name}-${url_hash}"
    echo "$workdir"
}

build() {
    name="$1"
    url="$2"
    compile_cmd="${3:-}"
    workdir=`getWorkdir "$name" "$url"`

    if [ "${BUILD_TARGET}" != 'all' ] && [ "${BUILD_TARGET}" != "${name}" ]; then
        return
    fi

    download "${name}" "${url}" "${workdir}"
    compile "${name}" "${workdir}" "${compile_cmd}"
}

download() {
    name="$1"
    url="$2"
    workdir="$3"

    if [ -d "${workdir}" ]; then
        echo "****** Skipping '${name}' download, dir already exists ******"
    else
        mkdir -p "${workdir}"
        echo "****** Downloading '${name}' to '${workdir}' ******"
        if ! wget -qO- "${url}" | bsdtar -xvf - -C "${workdir}" --strip-components=1; then
            echo "Error when downloading: '${url}"
            rm -rf "${workdir}"
            exit 1
        fi
        echo "Ok. '${name}' downloaded."
    fi
}

compile() {
    name="$1"
    workdir="$2"
    compile_cmd="$3"

    if [ -n "${compile_cmd}" ]; then
        echo "****** Compiling '${name}' ******"
        echo "Entering dir: '${workdir}'"
        cd "${workdir}"
        
        if eval "$compile_cmd"; then
            echo "Ok. '${name}' compiled."
        else
            echo "ERROR when compiling '${name}'."
            exit 1
        fi
    fi
}