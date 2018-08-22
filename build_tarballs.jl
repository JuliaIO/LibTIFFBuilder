# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libtiff"
version = v"4.0.9"

# Collection of sources required to build libtiff
sources = [
    "https://gitlab.com/libtiff/libtiff.git" =>
    "020bd2fd3b4235b2175dafa9633d2b191c50e7cd",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libtiff/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtiff", :libtiff),
    LibraryProduct(prefix, "libtiffxx", :libtiffxx)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.2/build_Zlib.v1.2.11.jl",
    "https://github.com/SimonDanisch/LibpngBuilder/releases/download/1.0.0/build_libpng.v1.6.31.jl",
    "https://github.com/SimonDanisch/LibJPEGBuilder/releases/download/v9b/build_libjpeg.v9.0.0-b.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

