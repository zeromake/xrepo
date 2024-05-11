local function getVersion(version)
    local versions ={
        ["2024.05.10-alpha"] = "archive/a775bbc6fc9f13ad1e353b2acabcc4965e74885a.tar.gz",
    }
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

    add_versions("2024.05.10-alpha", "7e5742cd8e659b3f1d5ae00c1431807fd1f1d4a6fd15e9b66ba41964f2892ed3")
    add_versions("0.624", "6d5ce40a7dc0e17da51cc143d2ee1ab32727583c315938f5a69d13ef93ae574d")

    add_configs("extern_c", {description = "extern C", default = false, type = "boolean"})

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            extern_c = (package:config("extern_c") and "y" or "n")
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
