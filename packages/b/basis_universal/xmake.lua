package("basis_universal")
    set_homepage("https://github.com/BinomialLLC/basis_universal")
    set_description("Basis Universal GPU Texture Codec")
    set_license("Apache-2.0")
    set_urls("https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v$(version).tar.gz", {
        version = function (version)
            return tostring(version):gsub("%.", "_"):gsub("-release", "_")
        end
    })

    --insert version
    add_versions("1.50.0-release2", "0ef344cc7e3373ca9c15de2bd80512ea4ea17e09ed895febdf9e70f6c789bc27")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        package:addenv("PATH", "bin")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
