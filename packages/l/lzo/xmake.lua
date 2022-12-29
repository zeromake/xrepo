package("lzo")
    set_homepage("https://www.oberhumer.com/opensource/lzo/")
    set_description("real-time data compression library")
    set_license("MIT")
    set_urls("https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz")
    
    add_versions("2.10", "c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072")

    on_load(function (package)
        if package:is_plat("windows", "mingw") and package:config("shared") then
            ackage:add("defines", "__LZO_EXPORT1=__declspec(dllexport)")
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("config.h.in", [[
#ifndef __LZO_AUTOCONF_CONFIG_H_INCLUDED
#define __LZO_AUTOCONF_CONFIG_H_INCLUDED 1

${define HAVE_ASSERT_H}
${define HAVE_CTYPE_H}
${define HAVE_DIRENT_H}
${define HAVE_ERRNO_H}
${define HAVE_FCNTL_H}
${define HAVE_FLOAT_H}
${define HAVE_LIMITS_H}
${define HAVE_MALLOC_H}
${define HAVE_MEMORY_H}
${define HAVE_SETJMP_H}
${define HAVE_SIGNAL_H}
${define HAVE_STDARG_H}
${define HAVE_STDDEF_H}
${define HAVE_STDINT_H}
${define HAVE_STDIO_H}
${define HAVE_STDLIB_H}
${define HAVE_STRING_H}
${define HAVE_STRINGS_H}
${define HAVE_TIME_H}
${define HAVE_UNISTD_H}
${define HAVE_UTIME_H}
${define HAVE_SYS_MMAN_H}
${define HAVE_SYS_RESOURCE_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TIME_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_SYS_WAIT_H}

${define SIZEOF_SHORT}
${define SIZEOF_INT}
${define SIZEOF_LONG}
${define SIZEOF_LONG_LONG}
${define SIZEOF___INT16}
${define SIZEOF___INT32}
${define SIZEOF___INT64}
${define SIZEOF_VOID_P}
${define SIZEOF_SIZE_T}
${define SIZEOF_PTRDIFF_T}
${define SIZEOF_INTMAX_T}
${define SIZEOF_UINTMAX_T}
${define SIZEOF_INTPTR_T}
${define SIZEOF_UINTPTR_T}
${define SIZEOF_FLOAT}
${define SIZEOF_DOUBLE}
${define SIZEOF_LONG_DOUBLE}
${define SIZEOF_DEV_T}
${define SIZEOF_FPOS_T}
${define SIZEOF_MODE_T}
${define SIZEOF_OFF_T}
${define SIZEOF_SSIZE_T}
${define SIZEOF_TIME_T}

${define HAVE_ACCESS}
${define HAVE_ALLOCA}
${define HAVE_ATEXIT}
${define HAVE_ATOI}
${define HAVE_ATOL}
${define HAVE_CHMOD}
${define HAVE_CHOWN}
${define HAVE_CLOCK_GETCPUCLOCKID}
${define HAVE_CLOCK_GETRES}
${define HAVE_CLOCK_GETTIME}
${define HAVE_CTIME}
${define HAVE_DIFFTIME}
${define HAVE_FSTAT}
${define HAVE_GETENV}
${define HAVE_GETPAGESIZE}
${define HAVE_GETRUSAGE}
${define HAVE_GETTIMEOFDAY}
${define HAVE_GMTIME}
${define HAVE_ISATTY}
${define HAVE_LOCALTIME}
${define HAVE_LONGJMP}
${define HAVE_LSTAT}
${define HAVE_MEMCMP}
${define HAVE_MEMCPY}
${define HAVE_MEMMOVE}
${define HAVE_MEMSET}
${define HAVE_MKDIR}
${define HAVE_MKTIME}
${define HAVE_MMAP}
${define HAVE_MPROTECT}
${define HAVE_MUNMAP}
${define HAVE_QSORT}
${define HAVE_RAISE}
${define HAVE_RMDIR}
${define HAVE_SETJMP}
${define HAVE_SIGNAL}
${define HAVE_SNPRINTF}
${define HAVE_STRCASECMP}
${define HAVE_STRCHR}
${define HAVE_STRDUP}
${define HAVE_STRERROR}
${define HAVE_STRFTIME}
${define HAVE_STRICMP}
${define HAVE_STRNCASECMP}
${define HAVE_STRNICMP}
${define HAVE_STRRCHR}
${define HAVE_STRSTR}
${define HAVE_TIME}
${define HAVE_UMASK}
${define HAVE_UTIME}
${define HAVE_VSNPRINTF}

#if defined __BIG_ENDIAN__
#define WORDS_BIGENDIAN 1
#endif

/* Enable large inode numbers on Mac OS X 10.5.  */
#ifndef _DARWIN_USE_64_BIT_INODE
# define _DARWIN_USE_64_BIT_INODE 1
#endif

#endif /* already included */
        ]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("lzo1_compress", {includes = {"lzo/lzo1.h"}}))
    end)
