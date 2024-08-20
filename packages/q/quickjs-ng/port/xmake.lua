add_rules("mode.debug", "mode.release")

set_languages("c11")

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

option("libc")
    set_default(true)
    set_showmenu(true)
option_end()

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cflags("/experimental:c11atomics", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines(
        "UNICODE",
        "_UNICODE",
        "WIN32_LEAN_AND_MEAN",
        "_WIN32_WINNT=0x0602",
        "_CRT_SECURE_NO_WARNINGS"
    )
end

set_encodings("utf-8")

add_defines(
    "CONFIG_BIGNUM=1",
    "_GNU_SOURCE"
)

target("quickjs")
    set_kind("$(kind)")
    add_files(
        "cutils.c",
        "libbf.c",
        "libregexp.c",
        "libunicode.c",
        "quickjs.c"
    )
    add_headerfiles("quickjs.h", {prefixdir = "quickjs"})
    if get_config("libc") then
        add_files("quickjs-libc.c")
    end

if get_config("cli") then
    includes("rules/embed-js.lua")
    target("qjsc")
        set_default(false)
        add_files("qjsc.c")
        add_deps("quickjs")

    target("qjs")
        set_default(true)
        add_rules("embed-js", {argv = {"-fbignum", "-c"}})
        add_files("qjs.c", "repl.js")
        add_deps("qjsc")
        if is_plat("windows", "mingw") then
            add_files("resource.rc")
        end
end
