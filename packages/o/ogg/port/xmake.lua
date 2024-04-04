if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end


set_configvar("SIZE16", "int16_t")
set_configvar("USIZE16", "uint16_t")
set_configvar("SIZE32", "int32_t")
set_configvar("USIZE32", "uint32_t")
set_configvar("SIZE64", "int64_t")
set_configvar("USIZE64", "uint64_t")
configvar_check_cincludes("INCLUDE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("INCLUDE_STDINT_H", "stdint.h")
configvar_check_cincludes("INCLUDE_SYS_TYPES_H", "sys/types.h")

add_configfiles("build/config_types.h.in")

target("ogg")
    set_kind("$(kind)")
    add_includedirs("include")
    add_includedirs("$(buildir)")

    add_headerfiles("$(buildir)/config_types.h", {prefixdir = "ogg"})
    add_headerfiles("include/ogg/*.h", {prefixdir = "ogg"})
    add_files("src/*.c")
    if is_plat("windows", "mingw") then
        add_files("win32/ogg.def")
    end
