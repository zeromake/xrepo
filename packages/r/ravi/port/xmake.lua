if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("jit")
    set_default(true)
    set_showmenu(true)
    set_description("enable MIR JIT")
option_end()

option("compiler")
    set_default(true)
    set_showmenu(true)
    set_description("Controls whether to link in RaviComp")
option_end()

local LUA_CORE_SRCS = {
    "src/lapi.c",
    "src/lcode.c",
    "src/lctype.c",
    "src/ldebug.c",
    "src/ldo.c",
    "src/ldump.c",
    "src/lfunc.c",
    "src/lgc.c",
    "src/llex.c",
    "src/lmem.c",
    "src/lobject.c",
    "src/lopcodes.c",
    "src/lparser.c",
    "src/lstate.c",
    "src/lstring.c",
    "src/ltable.c",
    "src/ltm.c",
    "src/lundump.c",
    "src/lvm.c",
    "src/lzio.c",
    "src/ravi_jit.c",
    "src/ltests.c",
    "src/ravi_profile.c",
    "src/ravi_membuf.c",
    "src/ravi_jitshared.c",
    "src/bit.c",
    "src/ravi_alloc.c",
}

local LUA_LIB_SRCS = {
    "src/lauxlib.c",
    "src/lbaselib.c",
    "src/lbitlib.c",
    "src/lcorolib.c",
    "src/ldblib.c",
    "src/liolib.c",

    "src/lmathlib.c",
    "src/loslib.c",
    "src/ltablib.c",
    "src/lstrlib.c",
    "src/loadlib.c",
    "src/linit.c",
    "src/lutf8lib.c",
}

local JIT_SRCS = {}
local RAVICOMP_SRCS = {
    "src/ravi_complib.c"
}
if get_config("jit") then
    table.insert(JIT_SRCS, "src/ravi_mirjit.c")
else
    table.insert(JIT_SRCS, "src/ravi_nojit.c")
end

target("c2mir")
    set_default(false)
    set_kind("object")
    -- set_kind("$(kind)")
    add_includedirs("mir")
    add_files(
        "mir/mir.c",
        "mir/mir-gen.c",
        "mir/c2mir/c2mir.c"
    )

target("ravicomp")
    set_default(false)
    set_kind("object")
    -- set_kind("$(kind)")
    add_includedirs("ravicomp/include")
    add_includedirs("ravicomp/src")
    add_files("ravicomp/src/*.c")
    add_files("ravicomp/src/chibicc/*.c")

target("ravi")
    set_kind("$(kind)")
    add_includedirs("include", "mir", "mir/c2mir")
    add_files(unpack(LUA_LIB_SRCS))
    add_files(unpack(LUA_CORE_SRCS))
    add_files(unpack(JIT_SRCS))
    add_headerfiles(
        "include/lua.h",
        "include/lualib.h",
        "include/lauxlib.h",
        "include/luaconf.h",
        "include/lua.hpp"
    )
    if get_config("compiler") then
        add_files(unpack(RAVICOMP_SRCS))
        add_defines("USE_RAVICOMP=1")
        add_includedirs("ravicomp/include")
        add_deps("ravicomp")
    end
    if get_config("jit") then
        add_deps("c2mir")
        add_defines("USE_MIRJIT=1")
    end
    if is_plat("windows", "mingw") then
    elseif is_plat("iphoneos") then
        add_defines("LUA_USE_IOS")
    elseif is_plat("macosx") then
        add_defines("LUA_USE_MACOSX")
    else
        add_defines("LUA_USE_LINUX")
    end
    if not is_plat("windows") then
        add_defines("RAVI_USE_COMPUTED_GOTO")
        -- add_cflags("-fno-crossjumping", "-fno-gcse")
    end
    add_vectorexts("all")

target("ravi-cli")
    set_default(false)
    add_includedirs("include")
    add_files("src/lua.c")
    add_deps("ravi")

target("ravi-debugger")
    set_default(false)
    add_includedirs("include")
    add_files("vscode-debugger/src/*.c|testravidebug.c")
    add_deps("ravi")
