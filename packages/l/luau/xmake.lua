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
    add_versions("0.689", "d03c79ee496b732c72f405283ffec07185050ed993347e45a0c4a1518c8cb886")
    add_versions("0.673", "7587065619c1e63e781dcec895d9df9d8286730016d1ce2e51408f2b7e639314")
    add_versions("0.671", "c517da25dc4cdfed9587aeec8e38acc841c4b3bb2d4959869560222005e2ce69")
    add_versions("0.668", "3f0cfeb48bd106f654377e6b07e82c9c5a5f642ce4fe29cb0078fd3b1eff1bf6")
    add_versions("0.665", "18eaa819f892e9175ac6209fdbcb76f83f22e029f0faf09a4b9d6ff6e7818e8a")
    add_versions("0.663", "711bd5a18e4ae20fffd7394da669d7fc232626bb713a52936acc9f478620d84d")
    add_versions("0.661", "d55c99c8df926c600eb2cf654aa5c1c357e2715bee6b2b6cdaeb13fbc45f3f9e")
    add_versions("0.660", "9953b520f3515e3aa09df3896b91dc32141eaddaaac08a4e3758bd53683036e0")
    add_versions("0.656", "c5523f2381b3a107a0a4f3746e27c93d598fcac4d49a9562199e55c3c481fb10")
    add_versions("0.655", "1c0ff05ce18493d6c83062a17cf6822a71ce254bfa0db41dd086d313b674ca33")
    add_versions("0.654", "b40d75580df0e23fde5d4bbe43806c1098a32ac59902895f367ff2a0c41c013e")
    
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
