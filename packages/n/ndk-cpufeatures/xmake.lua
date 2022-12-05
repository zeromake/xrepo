package("ndk-cpufeatures")
    set_homepage("https://developer.android.com/ndk/guides/cpu-features")
    set_description("ndk cpu features")
    set_license("MIT")
    set_urls("https://github.com/zeromake/xrepo/releases/download/v$(version)/empty.zip")

    add_versions("0.0.1", "582d61eadf247a35e2b203776f5612fd35aeaaf80dd6bf8873fc13d6c0f175c0")

    add_includedirs("include")
    add_links("cpufeatures")

    on_install("android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("android_getCpuFamily()", {includes = {"cpu-features.h"}}))
    end)
