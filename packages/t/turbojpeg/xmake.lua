package("turbojpeg")
    set_homepage("https://libjpeg-turbo.org/")
    set_description("libjpeg-turbo is a JPEG image codec that uses SIMD instructions to accelerate baseline JPEG compression and decompression")
    set_license("ZLIB")
    set_urls("https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$(version).tar.gz")

    add_versions("3.0.2", "29f2197345aafe1dcaadc8b055e4cbec9f35aad2a318d61ea081f835af2eebe9")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
