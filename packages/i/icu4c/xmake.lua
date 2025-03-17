package("icu4c")
    set_homepage("http://site.icu-project.org/")
    set_description("C/C++ libraries for Unicode and globalization.")
    set_license("ICU")
    set_urls("https://github.com/unicode-org/icu/releases/download/release-$(version)-src.tgz", {
        version = function (version)
            return (version:gsub("%.", "-")) .. "/icu4c-" .. (version:gsub("%.", "_"))
        end,
    })
    --insert version
    add_versions("77.1", "ded3a96f6b7236d160df30af46593165b9c78a4ec72a414aa63cf50614e4c14e")
    add_versions("76.1", "a2c443404f00098e9e90acf29dc318e049d2dc78d9ae5f46efb261934a730ce2")
    add_versions("75.1", "cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ucnv_convert", {includes = "unicode/ucnv.h"}))
    end)
