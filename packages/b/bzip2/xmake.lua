package("bzip2")
    set_homepage("https://sourceware.org/bzip2")
    set_description("Freely available, patent free, high-quality data compressor.")

    set_license("zlib")
    set_urls("https://gitlab.com/bzip2/bzip2/-/archive/bzip2-$(version)/bzip2-bzip2-$(version).tar.gz")
    add_versions("1.0.8", "db106b740252669664fd8f3a1c69fe7f689d5cd4b132f82ba82b9afba27627df")

    add_includedirs("include")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

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
    end]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("BZ2_bzCompressInit", {includes = "bzlib.h"}))
    end)
