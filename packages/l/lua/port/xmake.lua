includes("@builtin/check")
add_rules("mode.debug", "mode.release")

set_languages("c99")

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

if is_plat("linux", "android") then
    add_defines("LUA_USE_LINUX")
elseif is_plat("macosx") then
    add_defines("LUA_USE_MACOSX")
elseif is_plat("iphoneos") then
    add_defines("LUA_USE_IOS")
elseif is_plat("windows") then
    add_defines("LUA_USE_WINDOWS")
end

target("lua")
    set_kind("$(kind)")
    add_files("src/*.c|lua.c|luac.c|onelua.c")
    add_headerfiles("src/lua.h", "src/luaconf.h", "src/lualib.h", "src/lauxlib.h", "src/lua.hpp")

target("lua-cli")
    set_kind("binary")
    add_deps("lua")
    add_files("src/lua.c")

target("luac-cli")
    set_kind("binary")
    add_deps("lua")
    add_files("src/luac.c")
