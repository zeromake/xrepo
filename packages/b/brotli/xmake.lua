package("brotli")
    set_homepage("https://github.com/google/brotli")
    set_description("Brotli is a generic-purpose lossless compression algorithm.")

    set_license("MIT")
    set_urls("https://github.com/google/brotli/archive/refs/tags/v$(version).tar.gz")
    --insert version
    add_versions("1.1.0", "e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff")
    add_versions("1.0.9", "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46")

    add_includedirs("include")
    on_install(function (package)
        os.rm("BUILD")
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("brotli")
    set_kind("$(kind)")
    add_includedirs("c/include")
    if is_kind("shared") then
        add_defines("BROTLI_SHARED_COMPILATION")
    end
    add_headerfiles("c/include/brotli/*.h", {prefixdir = "brotli"})
    for _, f in ipairs({
        "c/common/*.c",
        "c/dec/*.c",
        "c/enc/*.c"
    }) do
        add_files(f)
    end]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("BrotliDecoderCreateInstance(NULL, NULL, NULL)", {includes = {"brotli/decode.h"}}))
    end)
