package("vorbis")
    set_homepage("https://github.com/xiph/vorbis")
    set_description("Reference implementation of the Ogg Vorbis audio format.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/xiph/vorbis/releases/download/v$(version)/libvorbis-$(version).tar.gz")

    add_versions("1.3.7", "0e982409a9c3fc82ee06e08205b1355e5c6aa4c36bca58146ef399621b0ce5ab")
    add_deps("ogg")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
