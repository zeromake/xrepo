local function getVersion(version)
    return tostring(version):gsub("%.", ""):gsub("-", ".")
end
package("abseil")
    set_homepage("https://github.com/abseil/abseil-cpp")
    set_description("Abseil Common Libraries (C++)")
    set_license("MIT")
    set_urls("https://github.com/abseil/abseil-cpp/releases/download/$(version)/abseil-cpp-$(version).tar.gz", {
        version = getVersion
    })

    add_versions("2024.01.16-2", "733726b8c3a6d39a4120d7e45ea8b41a434cdacde401cba500f14236c49b39dc")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
