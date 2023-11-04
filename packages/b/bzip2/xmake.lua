package("bzip2")
    set_homepage("https://sourceware.org/bzip2")
    set_description("Freely available, patent free, high-quality data compressor.")

    set_license("zlib")
    set_urls("https://sourceware.org/pub/bzip2/bzip2-$(version).tar.gz")
    add_versions("1.0.8", "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269")

    add_includedirs("include")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("bzip2")
    set_kind("$(kind)")
    add_headerfiles("bzlib.h")
    for _, f in ipairs({
        "blocksort.c",
        "huffman.c",
        "crctable.c",
        "randtable.c",
        "compress.c",
        "decompress.c",
        "bzlib.c",
    }) do
        add_files(f)
    end]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("BZ2_bzCompressInit", {includes = "bzlib.h"}))
    end)
