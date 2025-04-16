add_rules("mode.debug", "mode.release")

option("freetype")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("plutovg")

if get_config("freetype") then
    add_requires("freetype")
end

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

target("plutosvg")
    set_kind("$(kind)")
    set_encodings("utf-8")
    set_languages("c99")
    add_files("source/*.c")
    add_includedirs("source")
    add_defines("PLUTOSVG_BUILD")
    add_headerfiles("source/plutosvg.h")
    add_packages("plutovg")
    if is_kind("static") then
        add_defines("PLUTOSVG_BUILD_STATIC")
    end
    if get_config("freetype") then
        add_packages("freetype")
        add_defines("PLUTOSVG_HAS_FREETYPE=1")
    end
