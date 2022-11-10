package("brotli")
    set_homepage("https://github.com/google/brotli")
    set_description("Brotli is a generic-purpose lossless compression algorithm.")

    set_license("MIT")
    set_urls("https://github.com/google/brotli/archive/refs/tags/v$(version).tar.gz")
    add_versions("1.0.9", "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46")

    add_includedirs("include")
    on_install("windows", "macosx", "linux", function (package)
        os.rm("BUILD")
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("brotli")
    set_kind("$(kind)")
    add_includedirs("c/include")
    add_headerfiles("c/include/brotli/*.h", {prefixdir = "brotli"})
    for _, f in ipairs({
        "c/common/*.c",
        "c/dec/*.c",
        "c/enc/*.c"
    }) do
        add_files(f)
    end]])
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("BrotliDecoderCreateInstance(NULL, NULL, NULL)", {includes = {"brotli/decode.h"}}))
    end)
