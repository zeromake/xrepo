if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

function configvar_check_csymbol_exists(define_name, var_name, opt)
    configvar_check_csnippets(define_name, 'void* a =(void*)('..var_name..');', opt)
end

if is_plat("windows", "mingw") then
    set_configvar("HAVE_VISIBILITY", 0)
    set_configvar("DLL_VARIABLE", "__declspec (dllimport)", {quote = false})
else
    set_configvar("HAVE_VISIBILITY", 0)
    set_configvar("DLL_VARIABLE", "", {quote = false})
end

set_configvar("EILSEQ", 42)
set_configvar("ICONV_CONST", "const", {quote = false})
-- set_configvar("ENABLE_EXTRA", 1)
set_configvar("DOUBLE_SLASH_IS_DISTINCT_ROOT", 1)
set_configvar("GNULIB_CANONICALIZE_LGPL", 1)
set_configvar("prefix", "@prefix@", {quote = false})
configvar_check_ctypes("USE_MBSTATE_T", "mbstate_t", {includes = {"wchar.h"}})
configvar_check_cincludes("BROKEN_WCHAR_H", "wchar.h")
configvar_check_cincludes("HAVE_WCHAR_H", "wchar.h")
configvar_check_cincludes("HAVE_CRTDEFS_H", "crtdefs.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_SDKDDKVER_H", "sdkddkver.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_SEARCH_H", "search.h")
configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
configvar_check_cincludes("HAVE_STDIO_H", "stdio.h")
configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
configvar_check_cincludes("HAVE_STRING_H", "string.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
configvar_check_cincludes("HAVE_WINSOCK2_H", "winsock2.h")

configvar_check_ctypes("HAVE_WCHAR_T", "wchar_t", {includes = {"wchar.h"}})
configvar_check_ctypes("HAVE_WINT_T", "wint_t", {includes = {"wchar.h"}})
configvar_check_ctypes("HAVE_LONG_LONG_INT", "long long int", {includes = {"stddef.h"}})
configvar_check_ctypes("HAVE_UNSIGNED_LONG_LONG_INT ", "unsigned long long int", {includes = {"stddef.h"}})
configvar_check_sizeof("BITSIZEOF_PTRDIFF_T", "ptrdiff_t", {includes = {"stddef.h"}})
configvar_check_sizeof("BITSIZEOF_SIG_ATOMIC_T", "sig_atomic_t", {includes = {"signal.h"}})
configvar_check_sizeof("BITSIZEOF_SIZE_T", "size_t", {includes = {"stddef.h"}})
configvar_check_sizeof("BITSIZEOF_WCHAR_T", "wchar_t", {includes = {"wchar.h"}})
configvar_check_sizeof("BITSIZEOF_WINT_T", "wint_t", {includes = {"wchar.h"}})
configvar_check_csnippets("C_ALLOCA", [[
#include <stdlib.h>
#include <stddef.h>
#ifndef alloca
# ifdef __GNUC__
#  define alloca __builtin_alloca
# elif defined _MSC_VER
#  include <malloc.h>
#  define alloca _alloca
# else
#  ifdef  __cplusplus
extern "C"
#  endif
void *alloca (size_t);
# endif
#endif

int main() {
    char *p = (char *)alloca(1);
    if (p) return 0;
    return 0;
}]])

set_configvar("GNULIB_FSCANF", 1)
set_configvar("GNULIB_SCANF", 1)
set_configvar("GNULIB_SIGPIPE", 1)
set_configvar("GNULIB_STDIO_SINGLE_THREAD", 1)
set_configvar("GNULIB_STRERROR", 1)
set_configvar("GNULIB_MSVC_NOTHROW", 1)
set_configvar("GNULIB_MSVC_NOTHROW", 1)
set_configvar("HAVE_DECL_ECVT", 1)
set_configvar("HAVE_DECL_FCLOSEALL", 1)
set_configvar("HAVE_DECL_GCVT", 1)
set_configvar("HAVE_DECL_WCSDUP", 1)
set_configvar("HAVE_DECL___ARGV", 1)
set_configvar("HAVE_ENVIRON_DECL", 1)
set_configvar("HAVE_MBRTOWC", 1)
set_configvar("HAVE_MBSTATE_T", 1)
set_configvar("HAVE_MEMMOVE", 1)
set_configvar("HAVE_MSVC_INVALID_PARAMETER_HANDLER", 1)
set_configvar("HAVE_RAISE", 1)
set_configvar("HAVE_WCRTOMB", 1)
set_configvar("HAVE_WINSOCK2_H", 1)
set_configvar("HAVE__BOOL", 1)
set_configvar("HAVE__SET_INVALID_PARAMETER_HANDLER", 1)
set_configvar("WORDS_LITTLEENDIAN", 1)
set_configvar("_USE_STD_STAT", 1)
set_configvar("__MINGW_USE_VC2005_COMPAT", 1)
set_configvar("__STDC_NO_VLA__", 1)
set_configvar("_GL_ASYNC_SAFE", 1)
set_configvar("mode_t", "int", {quote = false})
set_configvar("nlink_t", "int", {quote = false})
set_configvar("pid_t", "__int64", {quote = false})
set_configvar("restrict", "", {quote = false})
set_configvar("ssize_t", "__int64", {quote = false})
set_configvar("uid_t", "int", {quote = false})

add_configfiles("include/iconv.h.in", {filename = "iconv.h.inst", prefixdir = "iconv"})
add_configfiles("include/iconv.h.build.in", {filename = "iconv.h", prefixdir = "iconv"})
add_configfiles("include/iconv.h.in", {filename = "iconv.h.inst", prefixdir = "iconv"})

add_configfiles("libcharset/include/libcharset.h.build.in", {prefixdir = "libcharset", filename = "libcharset.h"})
add_configfiles("libcharset/include/libcharset.h.in", {prefixdir = "libcharset", filename = "libcharset.h.inst"})
add_configfiles("libcharset/include/localcharset.h.build.in", {prefixdir = "libcharset", filename = "localcharset.h"})
add_configfiles("libcharset/include/localcharset.h.in", {prefixdir = "libcharset", filename = "localcharset.h.inst"})

add_configfiles("config.h.in", {prefixdir = "iconv/config"})
add_configfiles("libcharset/config.h.in", {prefixdir = "libcharset/config"})

target("libcharset")
    set_kind("object")
    add_includedirs(
        "$(buildir)/libcharset/config",
        "$(buildir)/libcharset",
        "libcharset/include"
    )
    add_files(
        "libcharset/lib/localcharset.c",
        "libcharset/lib/relocatable-stub.c"
    )

target("iconv")
    set_kind("$(kind)")
    add_includedirs(
        "lib",
        "$(buildir)/iconv",
        "$(buildir)/iconv/config",
        "$(buildir)/libcharset"
    )
    add_files(
        "lib/iconv.c",
        "lib/relocatable.c"
    )
    add_deps("libcharset")
    add_headerfiles("$(buildir)/iconv/*.h", {prefixdir = "iconv"})
