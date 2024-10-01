
package("faudio")
    set_homepage("https://fna-xna.github.io")
    set_description("Accuracy-focused XAudio reimplementation for open platforms")
    set_license("MIT")
    set_urls("https://github.com/FNA-XNA/FAudio/archive/refs/tags/$(version).tar.gz", {
        version = function (version)
            return tostring(version):match("(%d+%.%d+)%.%d+")
        end
    })
    --insert version
    add_versions("24.10", "9d123c5f20ead7824f718b5840b87b432dbf51a0514214e30c41b4ee32a344e0")
    add_versions("24.09", "696ef2a0fb4c6208f239f21803ff3f39041d92db1769cf19e390782be07430b6")
    add_versions("24.07", "f7cd15ed111133fbc1ac387fa3e715b3a67d5e4cf59d8e290ac85d856d92367b")
    add_versions("24.06", "62a6d0e6254031e7a9f485afe4ad5fe35f86eafbf232f37d64ffc618bb89f703")
    add_versions("24.05.0", "9c5eb554a83325cb7b99bcffc02662c681b681679a11b78c66c21f1e1044beeb")
    add_versions("24.04", "a132b6c6162a5e110210c678ac0524dc3f0b0da9e845e64e68edd1a9a5da88e3")

    on_load(function (package)
        if package:is_plat("windows", "mingw") then
            package:add("defines", "FAUDIO_WIN32_PLATFORM")
            package:add(
                "syslinks",
                "dxguid",
                "uuid",
                "ole32",
                "mfplat",
                "mfreadwrite",
                "mfuuid",
                "propsys"
            )
        else
            package:add("deps", "sdl2")
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
