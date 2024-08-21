add_rules("mode.debug", "mode.release")

set_languages("c11")
set_encodings("utf-8")
set_plat(os.host())
set_arch(os.arch())

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


add_defines(
    "CONFIG_BIGNUM=1",
    "_GNU_SOURCE"
)

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

