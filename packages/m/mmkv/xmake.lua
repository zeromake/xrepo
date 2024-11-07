package("mmkv")
    set_homepage("https://github.com/Tencent/MMKV")
    set_description("An efficient, small mobile key-value storage framework developed by WeChat.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/Tencent/MMKV/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("2.0.0", "f43ef5e107816c7c53a1aa4eb6a12b12c281fdd399b8ba7d0feeefe843d5c63e")
    if is_plat("iphoneos", "watchos", "appletvos", "macosx") then
        add_defines("FORCE_POSIX")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets([[
            static void test() {
                auto mmkv = MMKV::defaultMMKV();
            }
        ]], {configs = {languages = "c++20"}, includes = {"mmkv/mmkv.h"}}))
    end)
