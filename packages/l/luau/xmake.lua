local function getVersion(version)
    local versions = {}
    if versions[tostring(version)] == nil then
        return "/archive/refs/tags/"..tostring(version)..".tar.gz"
    end
    return versions[tostring(version)]
end

package("luau")
    set_homepage("https://luau-lang.org")
    set_description("A fast, small, safe, gradually typed embeddable scripting language derived from Lua")
    set_license("MIT")
    set_urls("https://github.com/luau-lang/luau/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("0.652", "56c904c5ea25e537bdc8675ed52f5f0b56eb3d6e960fb9f93b8443229076f518")
    add_versions("0.650", "a605ae7a188455844ab131ff0d2df6f38c088142d6bd5eebb87795e619c3d7aa")
    add_versions("0.649", "a5bdce9052b7feb163b3488a7c9b4213353b846bb588e6d33ad9dbec41a02754")

    add_configs("extern_c", {description = "extern C", default = false, type = "boolean"})
    add_configs("cli", {description = "cli", default = false, type = "boolean"})

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            extern_c = package:config("extern_c") and "y" or "n",
            cli = package:config("cli") and "y" or "n"
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
