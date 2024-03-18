package("opus")
    set_homepage("https://opus-codec.org")
    set_description("Modern audio compression for the internet.")
    set_license("MIT")
    set_urls("https://github.com/xiph/opus/releases/download/v$(version)/opus-$(version).tar.gz")

    add_versions("1.4", "c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
