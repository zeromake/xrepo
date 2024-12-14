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

add_requires("zeromake.rules")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cflags("/experimental:c11atomics", {tools = {"clang_cl", "cl"}, force = true})
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
includes("rules/embed-js.lua")

add_defines(
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
    add_headerfiles("quickjs.h", "quickjs-libc.h", {prefixdir = "quickjs"})
    add_packages("zeromake.rules")
    add_rules("@zeromake.rules/export_symbol", {file = 'quickjs.sym'})
    if get_config("libc") then
        add_files("quickjs-libc.c")
    end

target("qjsc")
    add_files(
        "cutils.c",
        "libbf.c",
        "libregexp.c",
        "libunicode.c",
        "quickjs.c",
        "quickjs-libc.c",
        "qjsc.c"
    )
    if is_plat("windows", "mingw") then
        add_files("resource.rc")
    end
    set_policy("build.fence", true)

if get_config("cli") then
    target("qjs")
        add_rules("embed-js")
        add_files("qjs.c", "repl.js", "standalone.js")
        add_deps("quickjs", "qjsc")
        if is_plat("windows", "mingw") then
            add_files("resource.rc")
        end
end
