package("webp")
    set_homepage("https://chromium.googlesource.com/webm/libwebp")
    set_description("WebP codec is a library to encode and decode images in WebP format.")

    set_license("BSD-3-Clause")
    set_urls("https://github.com/webmproject/libwebp/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.3.2", "c2c2f521fa468e3c5949ab698c2da410f5dce1c5e99f5ad9e70e0e8446b86505")
    add_versions("1.2.4", "dfe7bff3390cd4958da11e760b65318f0a48c32913e4d5bc5e8d55abaaa2d32e")

    add_includedirs("include")
    if is_plat("android") then
        add_deps("ndk-cpufeatures")
    end
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("android") then
    add_requires("ndk-cpufeatures")
elseif is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

target("webp")
    set_kind("$(kind)")
    add_includedirs(".")
    add_headerfiles("src/webp/*.h", {prefixdir = "webp"})
    add_headerfiles("sharpyuv/*.h", {prefixdir = "sharpyuv"})
    if is_plat("android") then
        add_packages("ndk-cpufeatures")
        add_defines("HAVE_CPU_FEATURES_H=1")
    end
    for _, f in ipairs({
        "sharpyuv",
        "src/dec",
        "src/demux",
        "src/mux",
        "src/dsp",
        "src/enc",
        "src/utils",
    }) do
        add_files(path.join(f, "*.c"))
    end
    if is_kind("shared") and is_plat("windows", "mingw") then
        add_defines("WEBP_EXTERN=__declspec(dllexport)")
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("WebPGetDecoderVersion()", {includes = {"webp/decode.h"}}))
    end)
