includes("@builtin/check")
add_rules("mode.debug", "mode.release")

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
    set_languages("c++14")
else
    set_languages("c++11")
end

set_encodings("utf-8")

target("spirv_cross")
    set_kind("$(kind)")
    add_files(
        "spirv_cross.cpp",
        "spirv_parser.cpp",
        "spirv_cross_parsed_ir.cpp",
        "spirv_cfg.cpp"
    )

    add_files("spirv_cross_c.cpp")
    add_files("spirv_cpp.cpp")

    add_files("spirv_glsl.cpp")
    add_files("spirv_msl.cpp")
    add_files("spirv_hlsl.cpp")
    add_files("spirv_reflect.cpp")
    add_files("spirv_cross_util.cpp")
    add_defines("SPIRV_CROSS_VERSION=0.61.0")
    set_configvar("spirv-cross-build-version", "0.61.0")
    set_configvar("spirv-cross-timestamp", os.time(os.date("!*t")))
    add_configfiles("cmake/gitversion.in.h")

    add_includedirs("$(buildir)")

    add_headerfiles("include/spirv_cross/*.hpp", {prefixdir = "spirv_cross"})
    add_headerfiles("include/spirv_cross/*.h", {prefixdir = "spirv_cross"})
    add_headerfiles("*.hpp", {prefixdir = "spirv_cross"})

target("spirv_cross_cli")
    set_default(get_config("cli") or false)
    set_kind("binary")
    add_files("main.cpp")
    add_deps("spirv_cross")
