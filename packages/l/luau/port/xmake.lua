includes("@builtin/check")
add_rules("mode.debug", "mode.release")

option("cli")
    set_default(false)
    set_description("cli")
    set_showmenu(true)
option_end()

option("extern_c")
    set_default(false)
    set_description("extern C functions")
    set_showmenu(true)
    add_defines("LUA_USE_LONGJMP=1")
    if is_kind("shared") and is_plat("windows", "mingw") then
        add_defines(
            "LUA_API=extern \"C\" __declspec(dllexport)",
            "LUACODE_API=extern \"C\" __declspec(dllexport)",
            "LUACODEGEN_API=extern \"C\" __declspec(dllexport)"
        )
    else
        add_defines(
            "LUA_API=extern \"C\"",
            "LUACODE_API=extern \"C\"",
            "LUACODEGEN_API=extern \"C\""
        )
    end
option_end()

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_languages("c++17")
add_includedirs(
    "Common/include",
    "Ast/include",
    "Compiler/include",
    "Config/include",
    "Analysis/include",
    "CodeGen/include",
    "VM/include",
    "VM/src",
    "EqSat/include",
    "extern/isocline/include"
)

target("luau")
    set_kind("$(kind)")
    add_options("extern_c")
    add_headerfiles(
        "VM/include/lua.h",
        "VM/include/lualib.h",
        "VM/include/luaconf.h"
    )
    add_files(
        "Ast/src/*.cpp",
        "Compiler/src/*.cpp",
        "Config/src/*.cpp",
        "Analysis/src/*.cpp",
        "CodeGen/src/*.cpp",
        "VM/src/*.cpp",
        "EqSat/src/*.cpp"
    )

if get_config("cli") then
target("luau.cli")
    set_kind("object")
    add_files("CLI/FileUtils.cpp", "CLI/Flags.cpp")

target("luau.repl")
    set_kind("binary")
    add_options("extern_c")
    add_deps("luau", "luau.cli")
    add_files(
        "extern/isocline/src/isocline.c",
        "CLI/Coverage.cpp",
        "CLI/Profiler.cpp",
        "CLI/Repl.cpp",
        "CLI/ReplEntry.cpp",
        "CLI/Require.cpp"
    )

target("luau.analyze")
    set_kind("binary")
    add_options("extern_c")
    add_deps("luau", "luau.cli")
    add_files(
        "CLI/Analyze.cpp"
    )

target("luau.ast")
    set_kind("binary")
    add_options("extern_c")
    add_deps("luau", "luau.cli")
    add_files(
        "CLI/Ast.cpp"
    )
end
