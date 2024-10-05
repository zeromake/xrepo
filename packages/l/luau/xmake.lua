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
    add_versions("0.646", "6c9927ebbc1fc57b1ba41dbd8d2c561c10e05e1e00299c49c4b5bdfca4c26167")
    add_versions("0.645", "28aaa3e57e7adc44debedc6be9802f2625334eef0124ff722c8ab340dc6bbe1c")
    add_versions("0.643", "069702be7646917728ffcddcc72dae0c4191b95dfe455c8611cc5ad943878d3d")
    add_versions("0.634", "122c302f62edae41183287a16182db85703ada8ca489360da346686facac8915")
    add_versions("0.632", "61a3f6c02a6fe35b753e4286f922b24c6ce8b6f85aef57bb90b65891d7a8505a")
    add_versions("0.631", "485caec5a013315eee831edeb76f751fa57440046c05195674b18110f25694c4")
    add_versions("0.630", "601938ebd428d37c2bb10697500bff4fe304f7c0651cf64721b9dc5600a30ed9")

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
