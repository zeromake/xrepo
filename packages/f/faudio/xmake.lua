
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
    add_versions("25.10", "ca00bc7be82eeb975385ac490709817b662b6c148cb384242061d3a152131bde")
    add_versions("25.08", "af769d927d61e27074d3deff5af7a3cb0573054e163fbdace51d531d09a000a8")
    add_versions("25.05", "dbcf99a869da402d5f538e435ab7fd4992b2b255c9939e546f1905c3e6e80ff9")
    add_versions("25.04", "9f7a7beb1e9b7785e4de6ccefd10603f05076a3610e0764e964863cf2f09efd4")
    add_versions("25.03", "1eeb1d2d6ed038a68e6b0a02614d4c7f859aa0a22c4a64e0bd49c26573823ae8")
    add_versions("25.02", "eab667d231e5036b0e5c3c6f89fb4ea792284493d46161bc056a88a6dadc2683")
    add_versions("25.01", "044a79222ac01eb0e279f0204e403f01dfea03d29163a721ec266135dd09fb95")
    add_versions("24.12", "82feeb58301c4b7316ff6ee2201310073d8c9698ceb3f6f2cf5cc533dee0a415")
    add_versions("24.11", "7aa5fdc762e1abbf4721e793de589eced46eef872ee2b9a03ab79ac81b64082c")
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
