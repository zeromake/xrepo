add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("glslang", "spirv_tools")
set_languages("c++17")

target("shaderc")
    set_kind("$(kind)")
    add_packages("glslang", "spirv_tools")
    add_files("libshaderc_util/src/*.cc|*_test.cc")
    add_files("libshaderc/src/*.cc|*_test.cc")
    add_includedirs("libshaderc_util/include", "libshaderc/include")
    add_headerfiles("libshaderc/include/*.h", {prefixdir = "shaderc"})

target("glslc")
    set_default(get_config("cli") or false)
    add_files("glslc/src/*.cc|*_test.cc")
    add_packages("glslang", "spirv_tools")
    add_deps("shaderc")
    add_includedirs("libshaderc_util/include", "libshaderc/include", ".")
