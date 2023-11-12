if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

option("backend")
    set_default("")
    set_values("stb", "wic", "imageio", "common")
    set_showmenu(true)
option_end()

local options = {
    "avif",
    "jpeg",
    "png",
    "webp"
}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op, {system=false})
    end
end

add_requires("sdl2", {system=false})

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("sdl2_image")
    set_kind("$(kind)")
    check_cincludes("HAVE_STDINT_H", "stdint.h")
    check_cincludes("HAVE_STDIO_H", "stdio.h")
    check_cincludes("HAVE_STRING_H", "string.h")
    add_defines(
        "LOAD_SVG=1",
        "LOAD_GIF=1",
        "LOAD_BMP=1",
        "SDL_IMAGE_SAVE_PNG=1",
        "SDL_IMAGE_SAVE_JPG=1",
        "LOAD_TGA=1",
        "LOAD_LBM=1",
        "LOAD_PCX=1",
        "LOAD_PNM=1",
        "LOAD_XCF=1",
        "LOAD_XPM=1",
        "LOAD_XV=1",
        "LOAD_QOI=1"
    )
    add_packages("sdl2")
    add_headerfiles("SDL_image.h", {prefixdir="SDL2"})
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    if has_config("avif") then
        add_defines("LOAD_AVIF=1")
    end
    if has_config("webp") then
        add_defines("LOAD_WEBP=1")
    end
    if has_config("png") then
        add_defines("LOAD_PNG=1")
    end
    if has_config("jpeg") then
        add_defines("LOAD_JPG=1")
    end
    local backend = get_config("backend")
    if backend == "" or backend == nil then
        if is_plat("windows", "mingw") then
            backend = "wic"
        elseif is_plat("macosx", "iphoneos") then
            backend = "imageio"
        else
            backend = "stb"
        end
    end
    local files = {
        "*.c",
    }
    if is_plat("macosx", "iphoneos") then
        set_values("objc.build.arc", false)
        add_mflags("-fno-objc-arc")
        table.insert(files, "*.m")
    end
    if is_plat("macosx") then
        add_frameworks("CoreFoundation", "CoreGraphics", "ImageIO", "CoreServices")
    elseif is_plat("iphoneos") then
        add_frameworks("ImageIO", "CoreServices")
    end
    if backend == "wic" then
        add_defines("SDL_IMAGE_USE_WIC_BACKEND=1")
        add_defines("LOAD_PNG=1")
        add_defines("LOAD_JPG=1")
        add_defines("LOAD_TIF=1")
    elseif backend == "imageio" then
        add_defines("PNG_USES_IMAGEIO=1")
        add_defines("JPG_USES_IMAGEIO=1")
        if not is_plat("iphoneos") then
            add_defines("BMP_USES_IMAGEIO=1")
        end
        add_defines("LOAD_PNG=1")
        add_defines("LOAD_JPG=1")
        add_defines("LOAD_TIF=1")
    elseif backend == "stb" then
        add_defines("USE_STBIMAGE=1")
        add_defines("LOAD_PNG=1")
        add_defines("LOAD_JPG=1")
    elseif backend == "common" then
        add_defines("SDL_IMAGE_USE_COMMON_BACKEND=1")
    end
    for _, f in ipairs(files) do
        add_files(f)
    end
    remove_files(
        "showanim.c",
        "showimage.c"
    )
