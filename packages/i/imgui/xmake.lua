function getVersion(version)
    local versions = {
        ["latest"] = "archive/72ebd91567148b4d3dca073c7229c4c0462a0586.tar.gz"
    }
    local url = version == nil and versions["latest"] or versions[tostring(version)]
    return url ~= nil and url or "archive/refs/tags/v"..tostring(version)..".tar.gz"
end

package("imgui")
    set_homepage("https://github.com/ocornut/imgui")
    set_description("Dear ImGui: Bloat-free Graphical User interface for C++ with minimal dependencies")
    set_license("MIT")
    set_urls("https://github.com/ocornut/imgui/$(version)", {
        version=getVersion
    })
    add_versions("latest", "a7f32b55c6b8a3e6e66db27eb116f06e369664f948d894a442bd591952de7fc5")
    add_versions("1.89.9", "1acc27a778b71d859878121a3f7b287cd81c29d720893d2b2bf74455bf9d52d6")
    add_versions("1.89.8", "6680ccc32430009a8204291b1268b2367d964bd6d1b08a4e0358a017eb8e8c9e")

    add_configs("backend", {description = "Select backend", default = "", type = "string"})
    add_configs("freetype", {description = "Use freetype", default = false, type = "boolean"})

    add_includedirs("include")
    add_includedirs("include/imgui")

    on_load(function (package)
        if package:config("freetype") then
            package:add("deps", "freetype")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        table.insert(configs, "--backend="..package:config("backend"))
        table.insert(configs, "--freetype="..(package:config("freetype") and "y" or "n"))
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
