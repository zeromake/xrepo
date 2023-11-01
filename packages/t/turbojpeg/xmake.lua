package("turbojpeg")
    set_homepage("https://libjpeg-turbo.org/")
    set_description("libjpeg-turbo is a JPEG image codec that uses SIMD instructions to accelerate baseline JPEG compression and decompression")
    set_license("ZLIB")
    set_urls("https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.0.1.tar.gz")

    add_versions("3.0.1", "sha256")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
