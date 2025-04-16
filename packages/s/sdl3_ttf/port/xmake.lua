add_rules("mode.debug", "mode.release")

local sdlTTFPath = os.scriptdir()

option("harfbuzz")
    set_default(false)
    set_showmenu(true)
option_end()

option("plutosvg")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("freetype", "sdl3")
if has_config("harfbuzz") then
    add_requires("harfbuzz")
end
if has_config("plutosvg") then 
    add_requires("plutosvg")
end

target("sdl3_ttf")
    set_kind("$(kind)")
    add_packages("freetype", "sdl3")
    add_headerfiles("include/(SDL3_ttf/*.h)")
    add_includedirs("include")
    if has_config("harfbuzz") then
        add_packages("harfbuzz")
        add_defines(
            "TTF_USE_HARFBUZZ=1"
        )
    end
    if has_config("plutosvg") then
        add_packages("plutosvg")
        add_defines(
            "TTF_USE_PLUTOSVG=1"
        )
    end
    add_files("src/*.c")
