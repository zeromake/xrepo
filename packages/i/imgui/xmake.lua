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
    set_urls("https://github.com/ocornut/imgui/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.91.5", "2aa2d169c569368439e5d5667e0796d09ca5cc6432965ce082e516937d7db254")
    add_versions("1.91.4", "a455c28d987c78ddf56aab98ce0ff0fda791a23a2ec88ade46dd106b837f0923")
    add_versions("1.91.3", "29949d7b300c30565fbcd66398100235b63aa373acfee0b76853a7aeacd1be28")

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
