package("ndk-cpufeatures")
    set_homepage("https://developer.android.com/ndk/guides/cpu-features")
    set_description("ndk cpu features")
    set_license("MIT")

    on_install("android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("android_getCpuFamily()", {includes = {"cpu-features.h"}}))
    end)
