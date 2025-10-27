local options = {
    -- tls lib
    "mbedtls",
    "nettle",
    "openssl",

    -- decrypt lib
    -- "b2",
    -- "cng",

    -- compression lib
    "lz4",
    "lzo",
    "xz",
    "fxz",
    "zstd",
    "zlib",
    "bzip2",

    -- xml lib
    "xml2",
    "expat",
    "pcre2",

    -- other lib
    "iconv",
}

package("archive")
    set_homepage("https://github.com/libarchive/libarchive")
    set_description("Multi-format archive and compression library")
    set_license("MIT")
    set_urls("https://github.com/libarchive/libarchive/releases/download/v$(version)/libarchive-$(version).tar.xz")

    --insert version
    add_versions("3.8.2", "5f2d3c2fde8dc44583a61165549dc50ba8a37c5947c90fc02c8e5ce7f1cfb80d")
    add_versions("3.8.1", "bde832a5e3344dc723cfe9cc37f8e54bde04565bfe6f136bc1bd31ab352e9fab")
    add_versions("3.7.9", "aa90732c5a6bdda52fda2ad468ac98d75be981c15dde263d7b5cf6af66fd009f")
    add_versions("3.7.7", "4cc540a3e9a1eebdefa1045d2e4184831100667e6d7d5b315bb1cbc951f8ddff")
    add_versions("3.7.6", "b4071807367b15b72777c2eaac80f42c8ea2d20212ab279514a19fe1f6f96ef4")
    add_versions("3.7.5", "37556113fe44d77a7988f1ef88bf86ab68f53d11e85066ffd3c70157cc5110f1")
    add_versions("3.7.4", "7875d49596286055b52439ed42f044bd8ad426aa4cc5aabd96bfe7abb971d5e8")
    add_versions("3.7.3", "baa99e2bf584e088429faae17f9472942dba9158bbda288790b549560f9935a2")
    add_versions("3.7.2", "04357661e6717b6941682cde02ad741ae4819c67a260593dfb2431861b251acb")
    add_versions("3.6.1", "5a411aceb978f43e626f0c2d1812ddd8807b645ed892453acabd532376c148e6")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp("contrib/android/include/android_lf.h", "android_lf.h")
        io.writefile("config.h.in", [[
#ifndef __LIBARCHIVE_CONFIG_H_INCLUDED
#define __LIBARCHIVE_CONFIG_H_INCLUDED

${define VERSION}

${define HAVE_SYS_TYPES_H}
${define HAVE_ACL_LIBACL_H}
${define HAVE_ATTR_XATTR_H}
${define HAVE_CTYPE_H}
${define HAVE_COPYFILE_H}
${define HAVE_DIRECT_H}
${define HAVE_DLFCN_H}
${define HAVE_ERRNO_H}
${define HAVE_EXT2FS_EXT2_FS_H}

${define HAVE_FCNTL_H}
${define HAVE_GRP_H}
${define HAVE_INTTYPES_H}
${define HAVE_IO_H}
${define HAVE_LANGINFO_H}
${define HAVE_LIMITS_H}
${define HAVE_LINUX_TYPES_H}
${define HAVE_LINUX_FIEMAP_H}
${define HAVE_LINUX_FS_H}

${define HAVE_LINUX_MAGIC_H}
${define HAVE_LOCALE_H}
${define HAVE_MEMBERSHIP_H}
${define HAVE_MEMORY_H}
${define HAVE_PATHS_H}
${define HAVE_POLL_H}
${define HAVE_PROCESS_H}
${define HAVE_PTHREAD_H}
${define HAVE_PWD_H}
${define HAVE_READPASSPHRASE_H}
${define HAVE_REGEX_H}
${define HAVE_SIGNAL_H}
${define HAVE_SPAWN_H}
${define HAVE_STDARG_H}
${define HAVE_STDINT_H}
${define HAVE_STDLIB_H}
${define HAVE_STRING_H}
${define HAVE_STRINGS_H}
${define HAVE_SYS_ACL_H}
${define HAVE_SYS_CDEFS_H}
${define HAVE_SYS_EXTATTR_H}
${define HAVE_SYS_IOCTL_H}
${define HAVE_SYS_MKDEV_H}
${define HAVE_SYS_MOUNT_H}
${define HAVE_SYS_PARAM_H}
${define HAVE_SYS_POLL_H}
${define HAVE_SYS_RICHACL_H}
${define HAVE_SYS_SELECT_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_STATFS_H}
${define HAVE_SYS_STATVFS_H}
${define HAVE_SYS_SYSMACROS_H}
${define HAVE_SYS_TIME_H}
${define HAVE_SYS_UTIME_H}
${define HAVE_SYS_UTSNAME_H}
${define HAVE_SYS_VFS_H}
${define HAVE_SYS_WAIT_H}
${define HAVE_SYS_XATTR_H}
${define HAVE_TIME_H}
${define HAVE_UNISTD_H}
${define HAVE_UTIME_H}
${define HAVE_WCHAR_H}
${define HAVE_WCTYPE_H}
${define HAVE_WINDOWS_H}
${define HAVE_WINCRYPT_H}
${define HAVE_WINIOCTL_H}
${define HAVE_DIRENT_H}

${define HAVE__CrtSetReportMode}
${define HAVE_EFTYPE}
${define HAVE_EILSEQ}
${define HAVE_D_MD_ORDER}
${define HAVE_DECL_INT32_MAX}
${define HAVE_DECL_INT32_MIN}
${define HAVE_DECL_INT64_MAX}
${define HAVE_DECL_INT64_MIN}
${define HAVE_DECL_INTMAX_MAX}
${define HAVE_DECL_INTMAX_MIN}
${define HAVE_DECL_UINT32_MAX}
${define HAVE_DECL_UINT64_MAX}
${define HAVE_DECL_UINTMAX_MAX}
${define HAVE_DECL_SIZE_MAX}
${define HAVE_DECL_SSIZE_MAX}

${define HAVE_WORKING_EXT2_IOC_GETFLAGS}
${define HAVE_WORKING_FS_IOC_GETFLAGS}

${define HAVE_ARC4RANDOM_BUF}
${define HAVE_CHFLAGS}
${define HAVE_CHOWN}
${define HAVE_CHROOT}
${define HAVE_CTIME_R}
${define HAVE_FCHDIR}
${define HAVE_FCHFLAGS}
${define HAVE_FCHMOD}
${define HAVE_FCHOWN}
${define HAVE_FCNTL}
${define HAVE_FDOPENDIR}
${define HAVE_FORK}
${define HAVE_FSTAT}
${define HAVE_FSTATAT}
${define HAVE_FSTATFS}
${define HAVE_FSTATVFS}
${define HAVE_FTRUNCATE}
${define HAVE_FUTIMENS}
${define HAVE_FUTIMES}
${define HAVE_FUTIMESAT}
${define HAVE_GETEUID}
${define HAVE_GETGRGID_R}
${define HAVE_GETGRNAM_R}
${define HAVE_GETPWNAM_R}
${define HAVE_GETPWUID_R}
${define HAVE_GETPID}
${define HAVE_GETVFSBYNAME}
${define HAVE_GMTIME_R}
${define HAVE_LCHFLAGS}
${define HAVE_LCHMOD}
${define HAVE_LCHOWN}
${define HAVE_LINK}
${define HAVE_LINKAT}
${define HAVE_LOCALTIME_R}
${define HAVE_LSTAT}
${define HAVE_LUTIMES}
${define HAVE_MBRTOWC}
${define HAVE_MEMMOVE}
${define HAVE_MKDIR}
${define HAVE_MKFIFO}
${define HAVE_MKNOD}
${define HAVE_MKSTEMP}
${define HAVE_NL_LANGINFO}
${define HAVE_OPENAT}
${define HAVE_PIPE}
${define HAVE_POLL}
${define HAVE_POSIX_SPAWNP}
${define HAVE_READLINK}
${define HAVE_READPASSPHRASE}
${define HAVE_SELECT}
${define HAVE_SETENV}
${define HAVE_SETLOCALE}
${define HAVE_SIGACTION}
${define HAVE_STATFS}
${define HAVE_STATVFS}
${define HAVE_STRCHR}
${define HAVE_STRDUP}
${define HAVE_STRERROR}
${define HAVE_STRNCPY_S}
${define HAVE_STRNLEN}
${define HAVE_STRRCHR}
${define HAVE_SYMLINK}
${define HAVE_TIMEGM}
${define HAVE_TZSET}
${define HAVE_UNLINKAT}
${define HAVE_UNSETENV}
${define HAVE_UTIME}
${define HAVE_UTIMES}
${define HAVE_UTIMENSAT}
${define HAVE_VFORK}
${define HAVE_WCRTOMB}
${define HAVE_WCSCMP}
${define HAVE_WCSCPY}
${define HAVE_WCSLEN}
${define HAVE_WCTOMB}
${define HAVE__CTIME64_S}
${define HAVE__FSEEKI64}
${define HAVE__GET_TIMEZONE}
${define HAVE__GMTIME64_S}
${define HAVE__LOCALTIME64_S}
${define HAVE__MKGMTIME64}

${define HAVE_CYGWIN_CONV_PATH}
${define HAVE_FSEEKO}
${define HAVE_STRERROR_R}
${define HAVE_DECL_STRERROR_R}
${define HAVE_STRFTIME}
${define HAVE_VPRINTF}
${define HAVE_WMEMCMP}
${define HAVE_WMEMCPY}
${define HAVE_WMEMMOVE}
${define HAVE_DIRFD}
${define HAVE_READLINKAT}

${define HAVE_STRUCT_TM_TM_GMTOFF}
${define HAVE_STRUCT_TM___TM_GMTOFF}
${define HAVE_STRUCT_STATFS_F_NAMEMAX}
${define HAVE_STRUCT_STATFS_F_IOSIZE}
${define HAVE_STRUCT_STAT_ST_BIRTHTIME}
${define HAVE_STRUCT_STAT_ST_BIRTHTIMESPEC_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_MTIM_TV_NSEC}
${define HAVE_STRUCT_STAT_ST_MTIME_N}
${define HAVE_STRUCT_STAT_ST_UMTIME}
${define HAVE_STRUCT_STAT_ST_MTIME_USEC}
${define HAVE_STRUCT_STAT_ST_BLKSIZE}
${define HAVE_STRUCT_STAT_ST_FLAGS}
${define TIME_WITH_SYS_TIME}
${define HAVE_STRUCT_STATVFS_F_IOSIZE}

${define SIZEOF_SHORT}
${define SIZEOF_INT}
${define SIZEOF_LONG}
${define SIZEOF_LONG_LONG}
${define SIZEOF_UNSIGNED_SHORT}
${define SIZEOF_UNSIGNED}
${define SIZEOF_UNSIGNED_LONG}
${define SIZEOF_UNSIGNED_LONG_LONG}
${define HAVE___INT64}
${define HAVE_UNSIGNED___INT64}
${define HAVE_INT16_T}
${define HAVE_INT32_T}
${define HAVE_INT64_T}
${define HAVE_INTMAX_T}
${define HAVE_UINT8_T}
${define HAVE_UINT16_T}
${define HAVE_UINT32_T}
${define HAVE_UINT64_T}
${define HAVE_UINTMAX_T}

${define __INT64}
${define UNSIGNED___INT64}
${define INT16_T}
${define INT32_T}
${define INT64_T}
${define INTMAX_T}
${define UINT8_T}
${define UINT16_T}
${define UINT32_T}
${define UINT64_T}
${define UINTMAX_T}

${define HAVE_LZMA_STREAM_ENCODER_MT}
${define HAVE_LIBZ}
${define HAVE_ZLIB_H}
${define HAVE_LIBBZ2}
${define HAVE_BZLIB_H}
${define HAVE_LIBBZ2}
${define HAVE_BZLIB_H}
${define HAVE_LIBLZMA}
${define HAVE_LZMA_H}
${define HAVE_LIBLZO2}
${define HAVE_LZO_LZOCONF_H}
${define HAVE_LZO_LZO1X_H}
${define HAVE_LIBLZ4}
${define HAVE_LZ4_H}
${define HAVE_ZSTD_H}
${define HAVE_LIBMBEDCRYPTO}
${define HAVE_MBEDTLS_AES_H}
${define HAVE_MBEDTLS_MD_H}
${define HAVE_MBEDTLS_PKCS5_H}
${define HAVE_LIBNETTLE}
${define HAVE_NETTLE_AES_H}
${define HAVE_NETTLE_HMAC_H}
${define HAVE_NETTLE_MD5_H}
${define HAVE_NETTLE_PBKDF2_H}
${define HAVE_NETTLE_RIPEMD160_H}
${define HAVE_NETTLE_SHA_H}
${define HAVE_LIBCRYPTO}
${define HAVE_ICONV_H}
${define HAVE_LIBXML2}
${define HAVE_LIBEXPAT}


${define _FILE_OFFSET_BITS}

#ifndef NTDDI_VERSION
${define NTDDI_VERSION}
#endif // NTDDI_VERSION

#ifndef _WIN32_WINNT
${define _WIN32_WINNT}
#endif // _WIN32_WINNT

#ifndef WINVER
${define WINVER}
#endif // WINVER

/*
 * If we lack int64_t, define it to the first of __int64, int, long, and long long
 * that exists and is the right size.
 */
#if !defined(HAVE_INT64_T) && defined(HAVE___INT64)
typedef __int64 int64_t;
#define HAVE_INT64_T
#endif

#if !defined(HAVE_INT64_T) && SIZEOF_INT == 8
typedef int int64_t;
#define HAVE_INT64_T
#endif

#if !defined(HAVE_INT64_T) && SIZEOF_LONG == 8
typedef long int64_t;
#define HAVE_INT64_T
#endif

#if !defined(HAVE_INT64_T) && SIZEOF_LONG_LONG == 8
typedef long long int64_t;
#define HAVE_INT64_T
#endif

#if !defined(HAVE_INT64_T)
#error No 64-bit integer type was found.
#endif

/*
 * Similarly for int32_t
 */
#if !defined(HAVE_INT32_T) && SIZEOF_INT == 4
typedef int int32_t;
#define HAVE_INT32_T
#endif

#if !defined(HAVE_INT32_T) && SIZEOF_LONG == 4
typedef long int32_t;
#define HAVE_INT32_T
#endif

#if !defined(HAVE_INT32_T)
#error No 32-bit integer type was found.
#endif

/*
 * Similarly for int16_t
 */
#if !defined(HAVE_INT16_T) && SIZEOF_INT == 2
typedef int int16_t;
#define HAVE_INT16_T
#endif

#if !defined(HAVE_INT16_T) && SIZEOF_SHORT == 2
typedef short int16_t;
#define HAVE_INT16_T
#endif

#if !defined(HAVE_INT16_T)
#error No 16-bit integer type was found.
#endif

/*
 * Similarly for uint64_t
 */
#if !defined(HAVE_UINT64_T) && defined(HAVE_UNSIGNED___INT64)
typedef unsigned __int64 uint64_t;
#define HAVE_UINT64_T
#endif

#if !defined(HAVE_UINT64_T) && SIZEOF_UNSIGNED == 8
typedef unsigned uint64_t;
#define HAVE_UINT64_T
#endif

#if !defined(HAVE_UINT64_T) && SIZEOF_UNSIGNED_LONG == 8
typedef unsigned long uint64_t;
#define HAVE_UINT64_T
#endif

#if !defined(HAVE_UINT64_T) && SIZEOF_UNSIGNED_LONG_LONG == 8
typedef unsigned long long uint64_t;
#define HAVE_UINT64_T
#endif

#if !defined(HAVE_UINT64_T)
#error No 64-bit unsigned integer type was found.
#endif


/*
 * Similarly for uint32_t
 */
#if !defined(HAVE_UINT32_T) && SIZEOF_UNSIGNED == 4
typedef unsigned uint32_t;
#define HAVE_UINT32_T
#endif

#if !defined(HAVE_UINT32_T) && SIZEOF_UNSIGNED_LONG == 4
typedef unsigned long uint32_t;
#define HAVE_UINT32_T
#endif

#if !defined(HAVE_UINT32_T)
#error No 32-bit unsigned integer type was found.
#endif

/*
 * Similarly for uint16_t
 */
#if !defined(HAVE_UINT16_T) && SIZEOF_UNSIGNED == 2
typedef unsigned uint16_t;
#define HAVE_UINT16_T
#endif

#if !defined(HAVE_UINT16_T) && SIZEOF_UNSIGNED_SHORT == 2
typedef unsigned short uint16_t;
#define HAVE_UINT16_T
#endif

#if !defined(HAVE_UINT16_T)
#error No 16-bit unsigned integer type was found.
#endif

/*
 * Similarly for uint8_t
 */
#if !defined(HAVE_UINT8_T)
typedef unsigned char uint8_t;
#define HAVE_UINT8_T
#endif

#if !defined(HAVE_UINT16_T)
#error No 8-bit unsigned integer type was found.
#endif

/* Define intmax_t and uintmax_t if they are not already defined. */
#if !defined(HAVE_INTMAX_T)
typedef int64_t intmax_t;
#endif

#if !defined(HAVE_UINTMAX_T)
typedef uint64_t uintmax_t;
#endif

#ifdef SAFE_TO_DEFINE_EXTENSIONS
/* Enable extensions on AIX 3, Interix.  */
#ifndef _ALL_SOURCE
# define _ALL_SOURCE 1
#endif
/* Enable GNU extensions on systems that have them.  */
#ifndef _GNU_SOURCE
# define _GNU_SOURCE 1
#endif
/* Enable threading extensions on Solaris.  */
#ifndef _POSIX_PTHREAD_SEMANTICS
# define _POSIX_PTHREAD_SEMANTICS 1
#endif
/* Enable extensions on HP NonStop.  */
#ifndef _TANDEM_SOURCE
# define _TANDEM_SOURCE 1
#endif
/* Enable general extensions on Solaris.  */
#ifndef __EXTENSIONS__
# define __EXTENSIONS__ 1
#endif
#endif /* SAFE_TO_DEFINE_EXTENSIONS */

#endif
        ]], {encoding = "binary"})
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    -- end)
