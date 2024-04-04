add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

add_requires("ogg")

target("vorbis")
    set_kind("$(kind)")
    add_packages("ogg")
    add_includedirs("include")
    add_files("lib/*.c|psytune.c|tone.c")
    add_headerfiles("include/vorbis/*.h", {prefixdir = "vorbis"})
