local options = {
    "harfbuzz",
    "plutosvg",
}

package("sdl3_ttf")
    set_homepage("https://wiki.libsdl.org/SDL_ttf")
    set_description("Support for TrueType (.ttf) font files with Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_ttf/releases/download/release-$(version)/SDL3_ttf-$(version).tar.gz")

    --insert version
    add_versions("3.2.2", "63547d58d0185c833213885b635a2c0548201cc8f301e6587c0be1a67e1e045d")
    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    add_deps("freetype", "sdl3")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)
    -- on_test(function (package)
    --     assert(package:has_cfuncs("TTF_Init", {includes = {"SDL.h", "SDL_ttf.h"}}))
    -- end)
