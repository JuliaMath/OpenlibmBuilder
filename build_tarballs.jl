using BinaryBuilder

platforms = [
  BinaryProvider.Linux(:x86_64, :glibc)
]

sources = [
    "https://github.com/JuliaLang/openlibm/archive/v0.5.5.tar.gz" =>
    "07dcc5f59e695fb45167c81406b8e201c5ad91ebf24e3e55ae13298670910cfd",
]

common_flags="prefix=\$DESTDIR"
platform_data = Dict(
    Linux(:x86_64)     => ("ARCH=x86_64"),
    Linux(:i686)       => ("ARCH=i686"),
    Linux(:aarch64)    => ("ARCH=aarch64"),
    Linux(:armv7l)     => ("ARCH=arm"),
    Linux(:ppc64le)    => ("ARCH=ppc64le"),
    MacOS()            => ("ARCH=x86_64"),
    Windows(:x86_64)   => ("ARCH=x86_64"),
    Windows(:i686)     => ("ARCH=i686"),
)

for platform in keys(platform_data)
    platform_flags = platform_data[platform]

    flags = "$(platform_flags) $(common_flags)"

    script = """
    cd \${WORKSPACE}/srcdir/openlibm-0.5.5
    make $(flags) -j\${nproc}
    make $(flags) install
    """

    products = prefix -> [
        LibraryProduct(prefix, "libopenlibm")
    ]

    autobuild(pwd(), "openlibm", [platform], sources, script, products)
end

