add_rules("mode.debug", "mode.release")
includes("@builtin/check")

option("posix_api")
    set_default(false)
    set_showmenu(true)
    set_description("Use POSIX API")
option_end()

if is_plat("windows", "mingw") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

add_configfiles("config.h.in")

configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
configvar_check_cincludes("HAVE_SYS_UTIME_H", "sys/utime.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")

configvar_check_ctypes("HAVE_OFF_T", "off_t", {includes = {"sys/types.h"}})

configvar_check_sizeof("SIZEOF_INT", "int")
configvar_check_sizeof("SIZEOF_LONG", "long")
configvar_check_sizeof("SIZEOF_LONG_LONG", "long long")
configvar_check_sizeof("SIZEOF___INT64", "__int64")
configvar_check_sizeof("SIZEOF_OFF_T", "off_t", {includes = {"sys/types.h"}})
configvar_check_sizeof("SIZEOF_VOIDP", "void*")
configvar_check_sizeof("SIZEOF_FLOAT", "float")
configvar_check_sizeof("SIZEOF_DOUBLE", "double")
configvar_check_sizeof("SIZEOF_SIZE_T", "size_t")

configvar_check_csnippets("HAVE_ALLOCA", [[
#ifdef _WIN32
#include <malloc.h>
#include <stdlib.h>
#else
#include <alloca.h>
#endif

void test() {
    void* ptr = (void*)alloca;
}
]])

target("oniguruma")
    set_kind("$(kind)")
    add_files(
        "src/regerror.c",
        "src/regparse.c",
        "src/regext.c",
        "src/regcomp.c",
        "src/regexec.c",

        "src/reggnu.c",
        "src/regenc.c",
        "src/regsyntax.c",
        "src/regtrav.c",
        "src/regversion.c",

        "src/st.c",
        "src/onig_init.c",

        "src/unicode.c",
        "src/ascii.c",
        "src/utf8.c",
        "src/utf16_be.c",
        "src/utf16_le.c",

        "src/utf32_be.c",
        "src/utf32_le.c",
        "src/euc_jp.c",
        "src/sjis.c",
        "src/iso8859_1.c",

        "src/iso8859_2.c",
        "src/iso8859_3.c",
        "src/iso8859_4.c",
        "src/iso8859_5.c",

        "src/iso8859_6.c",
        "src/iso8859_7.c",
        "src/iso8859_8.c",
        "src/iso8859_9.c",

        "src/iso8859_10.c",
        "src/iso8859_11.c",
        "src/iso8859_13.c",
        "src/iso8859_14.c",

        "src/iso8859_15.c",
        "src/iso8859_16.c",
        "src/euc_tw.c",
        "src/euc_kr.c",
        "src/big5.c",

        "src/gb18030.c",
        "src/koi8_r.c",
        "src/cp1251.c",

        "src/euc_jp_prop.c",
        "src/sjis_prop.c",

        "src/unicode_unfold_key.c",

        "src/unicode_fold1_key.c",
        "src/unicode_fold2_key.c",
        "src/unicode_fold3_key.c"
    )
    add_includedirs("$(buildir)")
    add_headerfiles("src/oniguruma.h", "src/oniggnu.h")
    if get_config("posix_api") then
        add_files("src/regposix.c", "src/regposerr.c")
        add_headerfiles("src/onigposix.h")
        add_defines("USE_POSIX_API")
    end
    if is_kind("shared") then
        add_defines("ONIG_BUILD_LIBRARY")
    else
        add_defines("ONIG_STATIC")
    end
