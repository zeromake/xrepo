includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

add_requires("abseil_cpp")

target("re2")
    set_kind("$(kind)")
    add_packages("abseil_cpp")
    add_files("re2/*.cc", "util/*.cc")
    add_includedirs(".")
    set_languages("c++17")
    add_headerfiles(
        "re2/filtered_re2.h",
        "re2/re2.h",
        "re2/set.h",
        "re2/stringpiece.h",
        {prefixdir = "re2"}
    )

