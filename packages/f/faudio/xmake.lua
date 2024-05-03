
package("faudio")
    set_homepage("https://fna-xna.github.io")
    set_description("Accuracy-focused XAudio reimplementation for open platforms")
    set_license("MIT")
    set_urls("https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.05.tar.gz", {
        version = function (version)
            return version:match("(%d+%.%d+)%.%d+")
        end
    })
    add_versions("24.05.0", "9c5eb554a83325cb7b99bcffc02662c681b681679a11b78c66c21f1e1044beeb")

    on_load(function (package)
        if package:is_plat("windows", "mingw") then
            package:add("defines", "FAUDIO_WIN32_PLATFORM")
            package:add("syslinks", "dxguid", "uuid", "ole32", "mfplat", "mfreadwrite", "mfuuid", "propsys")
        end
    end)
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
