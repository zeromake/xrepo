add_rules("mode.debug", "mode.release")

local options = {
    "opus",
    "flac",
    "fluidsynth",
    "timidity",
    "mpg123",
    "xmp",
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

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sdlMixerFiles = {
    "src/*.c",
    "src/codecs/*.c",
    "src/codecs/native_midi/*.c",
}
target("sdl2_mixer")
    set_kind("$(kind)")
    add_includedirs(
        "include",
        "src",
        "src/codecs"
    )
    add_headerfiles("include/*.h", {prefixdir="SDL2"})
    add_packages("sdl2")
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end
    add_defines(
        "MUSIC_WAV=1",
        "MUSIC_OGG=1"
    )
    -- ogg
    if not has_config("opus") then
        add_defines("OGG_USE_STB=1")
    end

    -- mp3
    if has_config("mpg123") then
        add_defines("MUSIC_MP3_MPG123=1")
    else
        add_defines("MUSIC_MP3_DRMP3=1")
    end

    -- flac
    if has_config("flac") then
        add_defines("MUSIC_FLAC_LIBFLAC=1")
    else
        add_defines("MUSIC_FLAC_DRFLAC=1")
    end

    -- midi
    if has_config("fluidsynth") then
        add_defines("MUSIC_MID_FLUIDSYNTH=1")
    elseif has_config("timidity") then
        add_defines("MUSIC_MID_TIMIDITY=1")
    elseif is_plat("windows", "mingw", "macosx") then
        add_defines("MUSIC_MID_NATIVE=1")
    end

    -- xmp
    if has_config("xmp") then
        add_defines("MUSIC_MOD_XMP=1")
    end
    for _, f in ipairs(sdlMixerFiles) do
        add_files(f)
    end
