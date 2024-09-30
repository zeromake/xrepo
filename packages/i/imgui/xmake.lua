function getVersion(version)
    local versions = {
        ["2024.02.29-alpha"] = "archive/04f40014a62898d325cbc987c9f56073b2d17e73.tar.gz",
        ["2024.04.16-alpha"] = "archive/4cb0fe3c7dda31a033ce6f55d76aedd1c5893012.tar.gz",
    }
    local url = versions[tostring(version)]
    return url ~= nil and url or "archive/refs/tags/v"..tostring(version)..".tar.gz"
end

package("imgui")
    set_homepage("https://github.com/ocornut/imgui")
    set_description("Dear ImGui: Bloat-free Graphical User interface for C++ with minimal dependencies")
    set_license("MIT")
    set_urls("https://github.com/ocornut/imgui/$(version)", {
        version=getVersion
    })

    --insert version
    add_versions("1.91.1", "2c13a8909f75222c836abc9b3f60cef31c445f3f41f95d8242118ea789d145ca")
    add_versions("1.90.9", "04943919721e874ac75a2f45e6eb6c0224395034667bf508923388afda5a50bf")
    add_versions("1.90.8", "f606b4fb406aa0f8dad36d4a9dd3d6f0fd39f5f0693e7468abc02d545fb505ae")
    add_versions("1.90.7", "872574217643d4ad7e9e6df420bb8d9e0d468fb90641c2bf50fd61745e05de99")
    add_versions("1.90.6", "70b4b05ac0938e82b4d5b8d59480d3e2ca63ca570dfb88c55023831f387237ad")
    add_versions("1.90.5", "e94b48dba7311c85ba8e3e6fe7c734d76a0eed21b2b42c5180fd5706d1562241")
    add_versions("1.90.4", "5d9dc738af74efa357f2a9fc39fe4a28d29ef1dfc725dd2977ccf3f3194e996e")
    add_versions("1.90", "170986e6a4b83d165bfc1d33c2c5a5bc2d67e5b97176287485c51a2299249296")

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
