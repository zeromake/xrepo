local options = {
    "harfbuzz",
}

package("sdl2_ttf")
    set_homepage("https://wiki.libsdl.org/SDL_ttf")
    set_description("Support for TrueType (.ttf) font files with Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_ttf/releases/download/release-$(version)/SDL2_ttf-$(version).tar.gz")

    add_versions("2.20.1", "78cdad51f3cc3ada6932b1bb6e914b33798ab970a1e817763f22ddbfd97d0c57")
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

    add_deps("freetype", "sdl2")
    add_includedirs("include")

    on_install("windows", "mingw", "macosx", "linux", function (package)
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
    on_test(function (package)
        assert(package:has_cfuncs("TTF_Init", {includes = {"SDL.h", "SDL_ttf.h"}}))
    end)
