if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

local zlibPath = os.scriptdir()

target("zlib")
    set_kind("$(kind)")
    for _, f in ipairs({
        "adler32.c",
        "crc32.c",
        "deflate.c",
        "infback.c",
        "inffast.c",
        "inflate.c",
        "inftrees.c",
        "trees.c",
        "zutil.c",
        "compress.c",
        "uncompr.c",
        "gzclose.c",
        "gzlib.c",
        "gzread.c",
        "gzwrite.c",
    }) do
        add_files(path.join(zlibPath, f))
    end
    add_headerfiles("zlib.h", "zconf.h")
    check_cincludes("Z_HAVE_UNISTD_H", "unistd.h")
    check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
    check_cincludes("HAVE_STDINT_H", "stdint.h")
    check_cincludes("HAVE_STDDEF_H", "stddef.h")
    if is_plat("windows", "mingw") then
        add_defines("_CRT_SECURE_NO_DEPRECATE")
        add_defines("_CRT_NONSTDC_NO_DEPRECATE")
        if is_kind("shared") then
            add_files("win32/zlib1.rc")
            add_defines("ZLIB_DLL")
        end
    else
        add_defines("ZEXPORT=__attribute__((visibility(\"default\")))")
        add_defines("_LARGEFILE64_SOURCE=1")
    end
