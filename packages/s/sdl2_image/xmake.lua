local options = {
    "avif",
    "jpeg",
    "png",
    "webp"
}

package("sdl2_image")
    set_homepage("https://wiki.libsdl.org/SDL_image")
    set_description("Image decoding for many popular formats for Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_image/releases/download/release-$(version)/SDL2_image-$(version).tar.gz")

    add_versions("2.6.2", "48355fb4d8d00bac639cd1c4f4a7661c4afef2c212af60b340e06b7059814777")

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

    if is_plat("macosx") then
        add_frameworks("CoreFoundation", "CoreGraphics", "ImageIO", "CoreServices")
    elseif is_plat("iphoneos") then
        add_frameworks("ImageIO", "CoreServices")
    end

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
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
    --     assert(package:has_cfuncs("IMG_Init(0)", {includes = {"SDL_image.h"}}))
    -- end)
