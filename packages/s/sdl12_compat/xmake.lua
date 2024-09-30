package("sdl12_compat")
    set_homepage("https://github.com/libsdl-org/sdl12-compat")
    set_description("An SDL-1.2 compatibility layer that uses SDL 2.0 behind the scenes.")
    set_license("MIT")
    set_urls("https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-$(version).tar.gz")

    --insert version
    add_versions("1.2.68", "63c6e4dcc1154299e6f363c872900be7f3dcb3e42b9f8f57e05442ec3d89d02d")
    add_deps("sdl2")
    add_includedirs("include")
    add_includedirs("include/SDL2")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
