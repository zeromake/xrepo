local function getVersion(version)
    local versions ={
        ["2024.06.16-alpha"] = "archive/c5e9caed544466452c7275bedfa51d2d68b71657.tar.gz",
        ["2024.07.01-alpha"] = "archive/ec9d8c8861e3c5b4659c8be46d29b4ffc3d105cc.tar.gz",
        ["2024.07.04-alpha"] = "archive/b6c8d55ac402fd89e448153bc4f827ae1ee65840.tar.gz",
        ["2024.09.11-alpha"] = "archive/5666d4a9d576d5c19c9cf2cbd19079f49213407e.tar.gz",
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
    add_versions("2024.09.11-alpha", "9ed4df5012e17a5884b576008a220c8bd0d96e8afb9e1af9b26459210a3e217a")
    add_versions("2024.07.04-alpha", "a06091d2ec4630b78d5d2a2b5885a012c40c34626f6b3a79713ea4855f451cd9")
    add_versions("2024.07.01-alpha", "4dce788600bc75af5b731434381e00fef3d8a342ebc619365a04061542be4921")
    add_versions("2024.06.16-alpha", "aace412eca4a605660ca4027e2c2d468a9acd0d8a16c68ce6a95ed28bc6b6989")
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
