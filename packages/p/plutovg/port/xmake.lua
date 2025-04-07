add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("plutovg")
    set_kind("$(kind)")
    add_files("source/*.c")
    add_includedirs("include")
    add_headerfiles("include/*.h")
