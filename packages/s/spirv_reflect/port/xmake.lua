add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("spirv_reflect")
    set_kind("$(kind)")

    add_headerfiles("spirv_reflect.h")
    add_headerfiles("include/spirv/unified1/spirv.h", {prefixdir = "include/spirv/unified1"})
    add_files("spirv_reflect.c")
