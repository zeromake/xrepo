local function getVersion(version)
    local versions ={
        ["2024.04.03-alpha"] = "archive/2d08822f07847039b696ec4fb3d594e4c7b20847.tar.gz",
        ["2024.05.03-alpha"] = "archive/becc5b3e93b6e5d3a6bbf3f6efe56ad828928d27.tar.gz",
        ["2024.05.28-alpha"] = "archive/1b375923dd74367f3ebb58e2ee4dd95ccf7218fc.tar.gz",
        ["2024.06.16-alpha"] = "archive/c5e9caed544466452c7275bedfa51d2d68b71657.tar.gz",
        ["2024.07.01-alpha"] = "archive/ec9d8c8861e3c5b4659c8be46d29b4ffc3d105cc.tar.gz",
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

    add_versions("2024.07.01-alpha", "4dce788600bc75af5b731434381e00fef3d8a342ebc619365a04061542be4921")
    add_versions("2024.06.16-alpha", "aace412eca4a605660ca4027e2c2d468a9acd0d8a16c68ce6a95ed28bc6b6989")
    add_versions("2024.05.28-alpha", "5f202582b427e884e90291802fc6373a99e8951b702f43d5631151faa32bf132")
    add_versions("2024.05.03-alpha", "1752624e4901fbed30b8b78c1dc6f568ce0a716ce00588115af1c30f003f61db")
    add_versions("2024.04.03-alpha", "608cfd73dc6c787d03a0394bc4dd7877b1e4be3dc3b5b3f857d09f32d89c2fe8")
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
