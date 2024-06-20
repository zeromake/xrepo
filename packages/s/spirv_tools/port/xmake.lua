includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

add_requires("spirv_headers", "protobuf-cpp")

target("spirv_tools")
    set_kind("$(kind)")
    add_packages("spirv_headers", "protobuf-cpp")
    set_languages("c++17")
    add_files("source/*.cpp")
    add_files("source/util/*.cpp")
    add_files("source/val/*.cpp")
    add_files("source/opt/*.cpp")
    add_files("source/reduce/*.cpp")
    add_files("source/fuzz/*.cpp")
    add_files("source/fuzz/fact_manager/*.cpp")
    add_files("source/fuzz/pass_management/*.cpp")
    add_files("source/link/*.cpp")
    add_files("source/lint/*.cpp")
    add_files("source/diff/*.cpp")
    add_includedirs(".", "include", "$(buildir)")
    on_config("generate")
