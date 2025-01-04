local function getVersion(version)
    local versions ={
        ["2024.10.30-alpha"] = "archive/f6723fd940b993b39b1535f71c8695867a5e92d1.tar.gz",
        ["2024.11.22-alpha"] = "archive/e0a8f04615ecc5bbae0bec8b007ecb4816966ae5.tar.gz",
        ["2024.12.21-alpha"] = "archive/5eaee9f5f8f674aff4875c2b35db00758fa349d6.tar.gz",
        ["2024.12.28-alpha"] = "archive/4ef89209a239c1aea328cf13c05a2807e5c146d1.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("oniguruma")
    set_homepage("https://github.com/kkos/oniguruma")
    set_description("regular expression library")
    set_license("MIT")
    set_urls("https://github.com/kkos/oniguruma/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.12.28-alpha", "70bfed97ee8390f5ac08fea28e3e930a3b33df871c6fc1888c8d436c6c6b755d")
    add_versions("2024.12.21-alpha", "4387dbc332fcdb3f14633dd7df1db023bd395256a47b52f0d7b09f3b4a3de96c")
    add_versions("2024.11.22-alpha", "ee5db4741a86f5f60aa9f08a12d18e2a4991408e5e27409fed3bb2e31b5b46e3")
    add_versions("2024.10.30-alpha", "90e44780a94a48b5ca7de30feddf6c999cd847f38425bb17b21369a8330204ae")
    on_load(function (package) 
        if package:config("shared") ~= true then
            package:add("defines", "ONIG_STATIC")
        end
    end)
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp(path.join(os.scriptdir(), "port", "config.h.in"), "config.h.in")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("onig_new", {includes = {"oniguruma.h"}}))
    end)
