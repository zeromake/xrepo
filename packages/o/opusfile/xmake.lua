package("opusfile")
    set_homepage("Todo")
    set_description("Todo")
    set_license("MIT")
    set_urls("https://github.com/xiph/opusfile/releases/download/v$(version)/opusfile-$(version).tar.gz")

    add_versions("0.12", "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
