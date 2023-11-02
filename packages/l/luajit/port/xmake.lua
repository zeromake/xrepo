includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("luajit")
    set_kind("$(kind)")
    add_includedirs("src")

    add_headerfiles(
        "src/lua.h",
        "src/lualib.h",
        "src/lauxlib.h",
        "src/luaconf.h",
        "src/lua.hpp",
        "src/luajit.h"
    )
    add_files("src/lj_*.c", "src/lib_*.c")
    if is_arch("arm.*") then
        add_vectorexts("neon")
    else
        add_vectorexts("avx", "avx2")
        add_vectorexts("sse", "sse2", "sse3", "ssse3", "sse4.2")
    end
    if is_plat("windows", "mingw") then
        add_defines("LUAJIT_OS=LUAJIT_OS_WINDOWS")
        add_defines(
            "_CRT_SECURE_NO_DEPRECATE",
            "_CRT_STDIO_INLINE=__declspec(dllexport)__inline"
        )
        add_files("src/lj_vm.obj")
    elseif is_plat("macosx", "iphoneos") then
        add_files("src/lj_vm.S")
    else
        add_files("src/lj_vm.asm")
    end

    if is_plat("macosx") then
        add_defines("LUAJIT_OS=LUAJIT_OS_OSX")
        add_defines("LUAJIT_UNWIND_EXTERNAL", "_LARGEFILE_SOURCE", "_FILE_OFFSET_BITS=64")
        add_undefines("_FORTIFY_SOURCE")
        add_defines("TARGET_OS_IPHONE=0")
    elseif is_plat("iphoneos") then
        add_defines("LUAJIT_OS=LUAJIT_OS_OSX")
        add_defines("TARGET_OS_IPHONE=1")
    else
        add_defines("TARGET_OS_IPHONE=0")
    end
