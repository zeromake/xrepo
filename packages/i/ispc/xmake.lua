package("ispc")
    set_kind("binary")
    set_homepage("https://github.com/ispc/ispc")
    set_description("Intel® Implicit SPMD Program Compiler ")
    set_license("BSD-3-Clause")
    local pl = ""
    if os.host() == "windows" then
        pl = "windows.zip"
        add_versions("1.24.0", "a7c21cb2434f5364acbdf0933af6de49198458ed6f0b62012e03c3325c972649")
    elseif os.host() == "linux" then
        if os.arch():startswith("arm") then
            pl = "linux.aarch64.tar.gz"
            add_versions("1.24.0", "890ad5f31581091bf4ae9f235a7bb6fd9cabcbd6cf1670104ad61f1ad2da4c76")
        else
            pl = "linux.tar.gz"
            add_versions("1.24.0", "b3e5f71fd93aeaec7634179274b52572e59e700b8ff48c13d0f46708ee61a2c5")
        end
    elseif os.host() == "macosx" then
        pl = "macOS.universal.tar.gz"
        add_versions("1.24.0", "9281175df37a5407f076f083e240b8718d1ed699bd186f0014029feb5f8b799b")
    end
    add_urls("https://github.com/ispc/ispc/releases/download/v$(version)/ispc-v$(version)-"..pl)

    on_install(function (package)
        os.cp("bin/*", package:installdir("bin"))
        os.cp("lib/*", package:installdir("lib"))
        os.cp("include/*", package:installdir("include"))
        os.tryrm(package:installdir("lib/cmake"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
