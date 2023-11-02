package("yoga")
    set_homepage("https://yogalayout.com")
    set_description("Yoga is a cross-platform layout engine which implements Flexbox.")
    set_license("MIT")
    set_urls(
        "https://github.com/facebook/yoga/archive/220d2582c94517b59d1c36f1c2faf5e3f88306f1.zip"
    )
    add_versions("latest", "a4477216404e803ba91adfdf672339e2e0ca803ec104a0b31354fed066e5ed46")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("YGNodeNew", {includes = {"yoga/Yoga.h"}}))
    end)
