add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")
set_languages("c++17")
add_requires("plutovg")

target("lunasvg")
    set_kind("$(kind)")
    add_files("source/*.cpp")
    add_includedirs("include")
    add_headerfiles("include/*.h")
    add_packages("plutovg")
    add_defines("LUNASVG_BUILD")
    if is_kind("shared") then
        add_defines("LUNASVG_SHARED")
    else 
        add_defines("LUNASVG_BUILD_STATIC")
    end
