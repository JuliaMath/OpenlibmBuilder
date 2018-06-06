using BinaryBuilder

sources = [
    "https://github.com/JuliaLang/openlibm/archive/v0.5.5.tar.gz" =>
    "07dcc5f59e695fb45167c81406b8e201c5ad91ebf24e3e55ae13298670910cfd",
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
