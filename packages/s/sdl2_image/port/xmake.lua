includes("check_cincludes.lua")
add_rules("mode.debug", "mode.release")

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
        add_requires(op)
    end
end

add_requires("sdl2")

target("sdl2_image")
    set_kind("$(kind)")
    check_cincludes("HAVE_STDINT_H", "stdint.h")
    check_cincludes("HAVE_STDIO_H", "stdio.h")
    check_cincludes("HAVE_STRING_H", "string.h")
    add_defines(
        "LOAD_SVG=1",
        "LOAD_GIF=1",
        "LOAD_BMP=1",
        "LOAD_LBM=1",
        "LOAD_PCX=1",
        "LOAD_PNM=1",
        "LOAD_XCF=1",
        "LOAD_XPM=1",
        "LOAD_XV=1",
        "LOAD_TGA=1",
        "LOAD_JPG=1",
        "LOAD_PNG=1",
        "SDL_IMAGE_SAVE_PNG=1",
        "SDL_IMAGE_SAVE_JPG=1"
    )
    add_packages("sdl2")
    add_headerfiles("SDL_image.h")
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    if has_config("avif") then
        add_defines("LOAD_AVIF=1")
    end

    if not has_config("jpeg") or not has_config("png") then
        add_defines("USE_STBIMAGE=1")
    end

    if has_config("webp") then
        add_defines("LOAD_WEBP=1")
    end

    if is_plat("macosx", "iphoneos") then
        set_values("objc.build.arc", false)
        add_mflags("-fno-objc-arc")
    end
    local files = {
        "*.c",
    }
    if is_plat("macosx", "iphoneos") then
        table.insert(files, "*.m")
    end
    for _, f in ipairs(files) do
        add_files(f)
    end
