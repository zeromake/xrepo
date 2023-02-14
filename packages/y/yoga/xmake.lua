package("yoga")
    set_homepage("https://yogalayout.com")
    set_description("Yoga is a cross-platform layout engine which implements Flexbox.")
    set_license("MIT")
    set_urls("https://github.com/facebook/yoga/archive/refs/tags/v$(version).tar.gz")
    
    add_versions("1.19.0", "65a1b40390ab434a376cd8a60c4ab624185c982b5ed793c9d59111450e0b92d4")
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("YGNodeNew", {includes = {"yoga/Yoga.h"}}))
    end)
