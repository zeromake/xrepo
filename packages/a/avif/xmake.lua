package("avif")
    set_homepage("https://aomediacodec.github.io/av1-avif/")
    set_description("libavif - Library for encoding and decoding .avif files")
    set_license("MIT")
    set_urls("https://github.com/AOMediaCodec/libavif/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.0.1", "398fe7039ce35db80fe7da8d116035924f2c02ea4a4aa9f4903df6699287599c")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)


    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
