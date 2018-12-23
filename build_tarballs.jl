using BinaryBuilder

sources = [
    "https://github.com/JuliaMath/openlibm/archive/v0.6.0.tar.gz" =>
    "d45439093d1fd15e2ac3acf69955e462401c7a160d3330256cb4a86c51bdae28",
]

script = raw"""
# Enter the funzone
cd ${WORKSPACE}/srcdir/openlibm-*

# Install into output
flags="prefix=${prefix}"

# Build ARCH from ${target}
flags="${flags} ARCH=${target%-*-*}"

# Openlibm build system doesn't recognize our windows cross compilers properly
if [[ ${target} == *mingw* ]]; then
    flags="${flags} OS=WINNT"
fi

# Build the library
make ${flags} -j${nproc}

# Install the library
make ${flags} install
"""

platforms = supported_platforms()

products = prefix -> [
    LibraryProduct(prefix, "libopenlibm", :libopenlibm)
]

dependencies = [
]

build_tarballs(ARGS, "Openlibm", sources, script, platforms, products, dependencies)
