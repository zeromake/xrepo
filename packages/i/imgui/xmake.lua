function getVersion(version)
    local versions = {
        ["2023.12.21-docking"] = "archive/20e1caec858caa8123a6d52d410fa3f2578d3054.tar.gz"
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
    add_versions("2023.12.21-docking", "979d559f9ff4a3d8491242795df2e00e2b3eb75a46213d7eab03346e7df0ed87")
    add_versions("1.90", "170986e6a4b83d165bfc1d33c2c5a5bc2d67e5b97176287485c51a2299249296")
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
        local binary_to_compressed_c = package:installdir("bin").."/binary_to_compressed_c"
        if os.host() == "windows" or os.host() == "mingw" then
            binary_to_compressed_c = binary_to_compressed_c..".exe"
        end
        if os.exists(binary_to_compressed_c) then
            local fontDir = package:installdir("include/imgui/misc/fonts")
            if not os.exists(fontDir) then
                os.mkdir(fontDir)
            end
            for _, fontName in ipairs({
                "Cousine-Regular",
                "DroidSans",
                "Karla-Regular",
                "ProggyClean",
                "ProggyTiny",
                "Roboto-Medium",
            }) do
                local fontPath = "misc/fonts/"..fontName..".ttf"
                if os.exists(fontPath) then
                    fontName = fontName:gsub("-", "")
                    local outdata, errdata = os.iorunv(binary_to_compressed_c, {fontPath, fontName})
                    local f = io.open(path.join(fontDir, fontName..".h"), "wb")
                    f:write(outdata)
                    f:close()
                end
            end
        end
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
