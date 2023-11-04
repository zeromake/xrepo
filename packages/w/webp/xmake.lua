package("webp")
    set_homepage("https://chromium.googlesource.com/webm/libwebp")
    set_description("WebP codec is a library to encode and decode images in WebP format.")

    set_license("BSD-3")
    set_urls("https://github.com/webmproject/libwebp/archive/refs/tags/v$(version).tar.gz")
    add_versions("1.2.4", "dfe7bff3390cd4958da11e760b65318f0a48c32913e4d5bc5e8d55abaaa2d32e")

    add_includedirs("include")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

target("webp")
    set_kind("$(kind)")
    add_includedirs(".")
    add_headerfiles("src/webp/*.h", {prefixdir = "webp"})
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
    end]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("WebPGetDecoderVersion()", {includes = {"webp/decode.h"}}))
    end)
