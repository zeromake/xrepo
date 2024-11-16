package("c-ares")
    set_homepage("https://c-ares.org")
    set_description("A C library for asynchronous DNS requests")
    set_license("MIT")
    set_urls("https://github.com/c-ares/c-ares/releases/download/v1.33.1/c-ares-1.33.1.tar.gz")

    --insert version
    add_versions("1.34.3", "f66e9d71bdbca96b0a1a19a56331a84e0138de2e0778d41cbfe6785e44150588")
    add_versions("1.34.2", "ddedac85d77662a88501f07fc9cbae18df8f30850d97ec6432f092b933e32922")
    add_versions("1.34.1", "732fd9b8e1c51b507f3922fd87ba58d60184d05867714ff40c661397c1464f61")
    add_versions("1.33.1", "06869824094745872fa26efd4c48e622b9bd82a89ef0ce693dc682a23604f415")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "xmake.lua"), "./xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
