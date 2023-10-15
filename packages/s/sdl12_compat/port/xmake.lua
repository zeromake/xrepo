add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

add_requires("sdl2")

target("sdl12_compat")
    set_kind("$(kind)")
    add_packages("sdl2")
    add_files("src/SDL12_compat.c")
    add_headerfiles(path.join("include", "SDL", "*.h"), {prefixdir="SDL2"})
