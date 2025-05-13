package("mmkv")
    set_homepage("https://github.com/Tencent/MMKV")
    set_description("An efficient, small mobile key-value storage framework developed by WeChat.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/Tencent/MMKV/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("2.2.2", "0c7dcff4a94386c917bd1c0d3c7e53c90e12a1d68543a3486d576ccedceaaa31")
    add_versions("2.2.1", "c188f47c15539d1d3cea38cbc0d7e6ee2c3e4805f9617420425abeeae81546b9")
    add_versions("2.1.0", "6fa52248a4302f0c7a474e7e28e55f82f9625714a49e0eb69e13846f2c1af723")
    add_versions("2.0.2", "42508c7a5a469b884900dfe76f593e4b61f2ea0416c604a89235fe9dfed3fe26")
    add_versions("1.3.12", "dc6b012592b15cd528d01b75cc7de0ebc3bcc870471698e5981a433fa59e5890")
    add_versions("2.0.1", "bf484aa79fd6ba1c5ae1ec2d6465169ac4d2b60285e54c2da650ee460593ba88")
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
        ]], {configs = {languages = "c++20"}, includes = {"MMKV/MMKV.h"}}))
    end)
