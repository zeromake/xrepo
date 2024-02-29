
local function getVersion(version)
    local versions = {
        ['2022.01.09-alpha'] = 'archive/f12d7eb3ecebcfa5e2d3dc8a016772b3cd101f39.tar.gz'
    }
    return versions[tostring(version)]
end

package("fxz")
    set_homepage("https://github.com/conor42/fxz")
    set_description("FXZ Utils is a fork of XZ Utils. It adds a multi-threaded radix match finder and optimized encoder. The documentation, including this file, is based upon the XZ Utils documentation.")
    set_license("MIT")
    set_urls("https://github.com/conor42/fxz/$(version)", {version = getVersion})

    add_versions("2022.01.09-alpha", "dffa4ec239bd43db13b5cba8d18eecb3c34e10289d1c576cfb81066a0660e4c9")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("config.h.in", [[
${define ASSUME_RAM}
${define ENABLE_NLS}
${define HAVE_BSWAP_16}
${define HAVE_BSWAP_32}
${define HAVE_BSWAP_64}
${define HAVE_BYTESWAP_H}
${define HAVE_CAPSICUM}
${define HAVE_CC_SHA256_CTX}
${define HAVE_CC_SHA256_INIT}
${define HAVE_CFLOCALECOPYPREFERREDLANGUAGES}
${define HAVE_CFPREFERENCESCOPYAPPVALUE}
${define HAVE_CHECK_CRC32}
${define HAVE_CHECK_CRC64}
${define HAVE_CHECK_SHA256}
${define HAVE_CLOCK_GETTIME}
${define HAVE_COMMONCRYPTO_COMMONDIGEST_H}
${define HAVE_DCGETTEXT}
${define HAVE_DECL_CLOCK_MONOTONIC}
${define HAVE_DECL_PROGRAM_INVOCATION_NAME}
${define HAVE_DECODERS}
${define HAVE_DECODER_ARM}
${define HAVE_DECODER_ARMTHUMB}
${define HAVE_DECODER_DELTA}
${define HAVE_DECODER_IA64}
${define HAVE_DECODER_LZMA1}
${define HAVE_DECODER_LZMA2}
${define HAVE_DECODER_POWERPC}
${define HAVE_DECODER_SPARC}
${define HAVE_DECODER_X86}
${define HAVE_DLFCN_H}
${define HAVE_ENCODERS}
${define HAVE_ENCODER_ARM}
${define HAVE_ENCODER_ARMTHUMB}
${define HAVE_ENCODER_DELTA}
${define HAVE_ENCODER_IA64}
${define HAVE_ENCODER_LZMA1}
${define HAVE_ENCODER_LZMA2}
${define HAVE_ENCODER_POWERPC}
${define HAVE_ENCODER_SPARC}
${define HAVE_ENCODER_X86}
${define HAVE_FCNTL_H}
${define HAVE_FUTIMENS}
${define HAVE_FUTIMES}
${define HAVE_FUTIMESAT}
${define HAVE_GETOPT_H}
${define HAVE_GETOPT_LONG}
${define HAVE_GETTEXT}
${define HAVE_ICONV}
${define HAVE_IMMINTRIN_H}
${define HAVE_INTTYPES_H}
${define HAVE_LIMITS_H}
${define HAVE_MBRTOWC}
${define HAVE_MF_BT2}
${define HAVE_MF_BT3}
${define HAVE_MF_BT4}
${define HAVE_MF_HC3}
${define HAVE_MF_HC4}
${define HAVE_MF_RAD}
${define HAVE_MINIX_CONFIG_H}
${define HAVE_OPTRESET}
${define HAVE_POSIX_FADVISE}
${define HAVE_PTHREAD_CONDATTR_SETCLOCK}
${define HAVE_PTHREAD_PRIO_INHERIT}
${define HAVE_SHA256INIT}
${define HAVE_SHA256_CTX}
${define HAVE_SHA256_H}
${define HAVE_SHA256_INIT}
${define HAVE_SHA2_CTX}
${define HAVE_SHA2_H}
${define HAVE_SMALL}
${define HAVE_STDATOMIC_H}
${define HAVE_STDBOOL_H}
${define HAVE_STDINT_H}
${define HAVE_STDIO_H}
${define HAVE_STDLIB_H}
${define HAVE_STRINGS_H}
${define HAVE_STRING_H}
${define HAVE_STRUCT_STAT_ST_ATIMENSEC}
${define HAVE_STRUCT_STAT_ST_ATIMESPEC_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_ATIM_ST__TIM_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_ATIM_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_UATIME}
${define HAVE_SYS_BYTEORDER_H}
${define HAVE_SYS_CAPSICUM_H}
${define HAVE_SYS_ENDIAN_H}
${define HAVE_SYS_PARAM_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TIME_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_UINTPTR_T}
${define HAVE_UNISTD_H}
${define HAVE_STDBOOL_H}
${define HAVE_UTIME}
${define HAVE_UTIMES}
${define HAVE_VISIBILITY}
${define HAVE_WCHAR_H}
${define HAVE_WCWIDTH}
${define HAVE__BOOL}
${define HAVE__FUTIME}
${define HAVE__MM_MOVEMASK_EPI8}
${define HAVE___BUILTIN_ASSUME_ALIGNED}
${define HAVE___BUILTIN_BSWAPXX}
${define LT_OBJDIR}
${define MYTHREAD_POSIX}
${define MYTHREAD_VISTA}
${define MYTHREAD_WIN95}
${define NDEBUG}
${define PACKAGE}
${define PACKAGE_BUGREPORT}
${define PACKAGE_NAME}
${define PACKAGE_STRING}
${define PACKAGE_TARNAME}
${define PACKAGE_URL}
${define PACKAGE_VERSION}
${define PTHREAD_CREATE_JOINABLE}
${define SIZEOF_SIZE_T}
${define STDC_HEADERS}
${define TUKLIB_CPUCORES_CPUSET}
${define TUKLIB_CPUCORES_PSTAT_GETDYNAMIC}
${define TUKLIB_CPUCORES_SCHED_GETAFFINITY}
${define TUKLIB_CPUCORES_SYSCONF}
${define TUKLIB_CPUCORES_SYSCTL}
${define TUKLIB_FAST_UNALIGNED_ACCESS}
${define TUKLIB_PHYSMEM_AIX}
${define TUKLIB_PHYSMEM_GETINVENT_R}
${define TUKLIB_PHYSMEM_GETSYSINFO}
${define TUKLIB_PHYSMEM_PSTAT_GETSTATIC}
${define TUKLIB_PHYSMEM_SYSCONF}
${define TUKLIB_PHYSMEM_SYSCTL}
${define TUKLIB_PHYSMEM_SYSINFO}
${define TUKLIB_USE_UNSAFE_TYPE_PUNNING}
${define VERSION}
${define _FILE_OFFSET_BITS}
${define _LARGE_FILES}
${define _UINT32_T}
${define _UINT64_T}
${define _UINT8_T}
${define __GETOPT_PREFIX}
${define int32_t}
${define int64_t}
${define uint16_t}
${define uint32_t}
${define uint64_t}
${define uint8_t}
${define uintptr_t}

#ifndef _ALL_SOURCE
${define _ALL_SOURCE}
#endif
#ifndef _DARWIN_C_SOURCE
${define _DARWIN_C_SOURCE}
#endif
#ifndef __EXTENSIONS__
${define __EXTENSIONS__}
#endif
#ifndef _GNU_SOURCE
${define _GNU_SOURCE}
#endif
#ifndef _HPUX_ALT_XOPEN_SOCKET_API
${define _HPUX_ALT_XOPEN_SOCKET_API}
#endif
#ifndef _MINIX
${define _MINIX}
#endif
#ifndef _NETBSD_SOURCE
${define _NETBSD_SOURCE}
#endif
#ifndef _OPENBSD_SOURCE
${define _OPENBSD_SOURCE}
#endif
#ifndef _POSIX_SOURCE
${define _POSIX_SOURCE}
#endif
#ifndef _POSIX_1_SOURCE
${define _POSIX_1_SOURCE}
#endif
#ifndef _POSIX_PTHREAD_SEMANTICS
${define _POSIX_PTHREAD_SEMANTICS}
#endif
#ifndef __STDC_WANT_IEC_60559_ATTRIBS_EXT__
${define __STDC_WANT_IEC_60559_ATTRIBS_EXT__}
#endif
#ifndef __STDC_WANT_IEC_60559_BFP_EXT__
${define __STDC_WANT_IEC_60559_BFP_EXT__}
#endif
#ifndef __STDC_WANT_IEC_60559_DFP_EXT__
${define __STDC_WANT_IEC_60559_DFP_EXT__}
#endif
#ifndef __STDC_WANT_IEC_60559_FUNCS_EXT__
${define __STDC_WANT_IEC_60559_FUNCS_EXT__}
#endif
#ifndef __STDC_WANT_IEC_60559_TYPES_EXT__
${define __STDC_WANT_IEC_60559_TYPES_EXT__}
#endif
#ifndef __STDC_WANT_LIB_EXT2__
${define __STDC_WANT_LIB_EXT2__}
#endif
#ifndef __STDC_WANT_MATH_SPEC_FUNCS__
${define __STDC_WANT_MATH_SPEC_FUNCS__}
#endif
#ifndef _TANDEM_SOURCE
${define _TANDEM_SOURCE}
#endif
#ifndef _XOPEN_SOURCE
${define _XOPEN_SOURCE}
#endif

#if defined __BIG_ENDIAN__
#define WORDS_BIGENDIAN 1
#else
${define WORDS_BIGENDIAN}
#endif
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        io.writefile(path.join(package:installdir("include"), "lzma.h"), [[
#ifndef FLZMA_COMPATIBLE_H
#define FLZMA_COMPATIBLE_H

#include "flzma.h"

#endif
]], {encoding = "binary"})
    end)

    on_test(function (package)
        assert(package:has_cfuncs("lzma_version_number", {includes = {"flzma.h"}}))
    end)
