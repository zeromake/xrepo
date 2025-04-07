package("plutovg")
    set_homepage("https://github.com/sammycage/plutovg")
    set_description("Tiny 2D vector graphics library in C")
    set_license("MIT")
    set_urls("https://github.com/sammycage/plutovg/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.0.0", "d4a8015aee9eefc29b01e6dabfd3d4b371ae12f9d5e9be09798deb77a528a794")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
