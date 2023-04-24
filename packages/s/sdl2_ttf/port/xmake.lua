add_rules("mode.debug", "mode.release")

local sdlTTFPath = os.scriptdir()

option("harfbuzz")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("freetype", {system=false})
add_requires("sdl2", {system=false})
if has_config("harfbuzz") then 
    add_requires("harfbuzz", {system=false})
end

target("sdl2_ttf")
    set_kind("$(kind)")
    add_packages("freetype", "sdl2")
    add_headerfiles("*.h", {prefixdir="SDL2"})
    if has_config("harfbuzz") then
        add_packages("harfbuzz")
        add_defines(
            "TTF_USE_HARFBUZZ=1"
        )
    end
    for _, f in ipairs({
        "SDL_ttf.c"
    }) do
        add_files(path.join(sdlTTFPath, f))
    end
