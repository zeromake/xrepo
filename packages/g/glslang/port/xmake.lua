includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

target("glslang")
    set_kind("$(kind)")
    set_languages("c++17")
    if is_plat("windows", "mingw") then 
        add_files("glslang/OSDependent/Windows/*.cpp")
    elseif is_plat("wasm") then
        add_files("glslang/OSDependent/Web/*.cpp")
    else
        add_files("glslang/OSDependent/Unix/*.cpp")
    end 
    
    add_files("glslang/GenericCodeGen/*.cpp")
    add_files("glslang/MachineIndependent/*.cpp")
    add_files("glslang/MachineIndependent/preprocessor/*.cpp")
    add_files("glslang/HLSL/*.cpp")
    add_files("glslang/CInterface/*.cpp")
    add_files("glslang/ResourceLimits/*.cpp")
    set_pcheader("glslang/MachineIndependent/pch.h")

    add_headerfiles(
        "${buildir}/glslang/*.h",
        "glslang/Public/*.h",
        "glslang/Include/glslang_c_interface.h",
        "glslang/Include/glslang_c_shader_types.h",
        "glslang/Include/ResourceLimits.h",
        "glslang/Include/glslang_c_shader_types.h",
        "glslang/MachineIndependent/Versions.h",
        {prefixdir = "glslang"}
    )
    set_configvar("major", 14)
    set_configvar("minor", 2)
    set_configvar("patch", 0)
    set_configvar("flavor", 0)
    add_configfiles("glslang/build_info.h.in")
    set_configdir("${buildir}/glslang")
    add_includedirs("${buildir}", ".")
    add_defines("ENABLE_HLSL=1")

target("spirv")
    set_kind("$(kind)")
    set_languages("c++17")
    add_files("SPIRV/*.cpp")
    add_files("SPIRV/CInterface/*.cpp")
    add_includedirs("${buildir}", ".")
    add_headerfiles(
        "GlslangToSpv.h",
        "disassemble.h",
        "Logger.h",
        "spirv.hpp",
        "SPVRemapper.h",
        {prefixdir = "glslang/SPIRV"}
    )
    add_deps("glslang")
