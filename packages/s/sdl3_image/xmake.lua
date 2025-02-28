local options = {
    "avif",
    "jpeg",
    "png",
    "webp",
    "turbojpeg",
}

package("sdl3_image")
    set_homepage("https://wiki.libsdl.org/SDL_image")
    set_description("Image decoding for many popular formats for Simple Directmedia Layer.")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL_image/releases/download/release-$(version)/SDL3_image-$(version).tar.gz")

    --insert version
    add_versions("3.2.0", "1690baea71b2b4ded9895126cddbc03a1000b027d099a4fb4669c4d23d73b19f")
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

    add_deps("sdl3")

    if is_plat("windows", "mingw") then
        add_syslinks("windowscodecs")
    elseif is_plat("macosx") then
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

    on_test(function (package)
        assert(package:has_cfuncs("IMG_Load", {includes = {"SDL3_image/SDL_image.h"}}))
    end)
