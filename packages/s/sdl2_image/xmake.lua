local options = {
    "avif",
    "jpeg",
    "png",
    "webp",
    "turbojpeg",
}

package("sdl2_image")
    set_homepage("https://wiki.libsdl.org/SDL_image")
    set_description("Image decoding for many popular formats for Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_image/releases/download/release-$(version)/SDL2_image-$(version).tar.gz")

    --insert version
    add_versions("2.8.8", "2213b56fdaff2220d0e38c8e420cbe1a83c87374190cba8c70af2156097ce30a")
    add_versions("2.8.5", "8bc4c57f41e2c0db7f9b749b253ef6cecdc6f0b689ecbe36ee97b50115fff645")
    add_versions("2.8.4", "f7c06a8783952cfe960adccdd3d8472b63ab31475b4390d10cfdcc1aea61238f")
    add_versions("2.8.3", "4b000f2c238ce380807ee0cb68a0ef005871691ece8646dbf4f425a582b1bb22")
    add_versions("2.8.2", "8f486bbfbcf8464dd58c9e5d93394ab0255ce68b51c5a966a918244820a76ddc")
    add_versions("2.6.3", "931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c")
    add_configs("backend", {description = "Support backend", default = "", type = "string"})

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
        add_frameworks("CoreFoundation", "CoreGraphics", "ImageIO", "CoreServices")
    elseif is_plat("iphoneos") then
        add_frameworks("ImageIO", "CoreServices")
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
        table.insert(configs, "--backend="..package:config("backend"))
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("IMG_Init(0)", {includes = {"SDL_image.h"}}))
    -- end)
