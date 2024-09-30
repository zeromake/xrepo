local options = {
    "opus",
    "flac",
    "fluidsynth",
    "mpg123",
    "timidity",
    "xmp",
}

package("sdl2_mixer")
    set_homepage("https://wiki.libsdl.org/SDL_mixer")
    set_description("An audio mixer that supports various file formats for Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_mixer/releases/download/release-$(version)/SDL2_mixer-$(version).tar.gz")

    --insert version
    add_versions("2.8.0", "1cfb34c87b26dbdbc7afd68c4f545c0116ab5f90bbfecc5aebe2a9cb4bb31549")
    add_versions("2.6.3", "7a6ba86a478648ce617e3a5e9277181bc67f7ce9876605eea6affd4a0d6eea8f")
    add_versions("2.6.2", "8cdea810366decba3c33d32b8071bccd1c309b2499a54946d92b48e6922aa371")
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

    add_deps("sdl2")
    add_includedirs("include")
    add_includedirs("include/SDL2")

    if is_plat("macosx") then
        add_frameworks("AudioToolbox")
    end

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
    --     assert(package:has_cfuncs("Mix_Init(0)", {includes = {"SDL_mixer.h"}}))
    -- end)
