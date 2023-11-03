package("curl")
    set_homepage("https://curl.se")
    set_description("A library for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP. libcurl offers a myriad of powerful features")
    set_license("MIT")
    set_urls("https://github.com/curl/curl/releases/download/curl-$(version).tar.bz2", {version = function (version)
        return version:gsub("%.", "_") .. "/curl-" .. version
    end})

    add_versions("8.4.0", "e5250581a9c032b1b6ed3cf2f9c114c811fc41881069e9892d115cc73f9e88c6")
    add_versions("7.86.0", "f5ca69db03eea17fa8705bdfb1a9f58d76a46c9010518109bb38f313137e0a28")
    add_versions("7.85.0", "21a7e83628ee96164ac2b36ff6bf99d467c7b0b621c1f7e317d8f0d96011539c")

    add_configs("winrt", {description = "Support winrt", default = false, type = "boolean"})
    add_configs("wolfssl", {description = "use wolfssl", default = false, type = "boolean"})

    add_deps("zlib")
    add_includedirs("include")

    add_defines("BUILDING_LIBCURL")

    on_load(function (package)
        if is_plat("windows", "mingw") then
            package:add("syslinks", "ws2_32")
            if not package:config("winrt") then
                package:add("syslinks", "wldap32")
            end
        elseif package:is_plat("macosx", "iphoneos") then
            package:add("frameworks", "CoreFoundation", "Security")
        end

        if package:config("wolfssl") then
            package:add("deps", "wolfssl")
        elseif package:is_plat("windows", "mingw") then
            package:add("syslinks", "crypt32", "bcrypt", "advapi32")
        end
        if package:config("shared") ~= true then
            package:add("defines", "CURL_STATICLIB")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        -- if is_plat("windows", "mingw") then
        --     os.cp("lib/config-win32.h", "lib/curl_config.h")
        -- end
        io.writefile("curl_config.h.in", [[
#ifndef HEADER_CURL_CONFIG_H
#define HEADER_CURL_CONFIG_H

${define OS}

#if defined(_MSC_VER) && (_MSC_VER >= 1400)
#define _CRT_SECURE_NO_DEPRECATE 1
#define _CRT_NONSTDC_NO_DEPRECATE 1
#endif


${define WINVER}
${define _WIN32_WINNT}
${define HAVE_FREEADDRINFO}
${define HAVE_GETADDRINFO}
${define USE_WIN32_CRYPTO}

#if defined(HAVE_GETADDRINFO)
#define HAVE_GETADDRINFO_THREADSAFE 1
#endif

${define CURL_DISABLE_LDAP}
${define USE_WIN32_LDAP}
${define STDC_HEADERS}

${define HAVE_ARPA_INET_H}
${define HAVE_ARPA_TFTP_H}
${define HAVE_ASSERT_H}
${define HAVE_ERRNO_H}
${define HAVE_FCNTL_H}
${define HAVE_GSSAPI_GSSAPI_GENERIC_H}
${define HAVE_GSSAPI_GSSAPI_H}
${define HAVE_GSSAPI_GSSAPI_KRB5_H}
${define HAVE_IFADDRS_H}
${define HAVE_INTTYPES_H}
${define HAVE_IO_H}
${define HAVE_LBER_H}
${define HAVE_LDAP_H}
${define HAVE_LDAP_SSL_H}
${define HAVE_LIBGEN_H}
${define HAVE_IDN2_H}
${define HAVE_LIBPSL_H}
${define HAVE_LIBSSH2_H}
${define HAVE_LIBSSH_LIBSSH_H}
${define HAVE_LOCALE_H}
${define HAVE_NETDB_H}
${define HAVE_NETINET_IN_H}
${define HAVE_NETINET_TCP_H}
${define HAVE_LINUX_TCP_H}
${define HAVE_NET_IF_H}
${define HAVE_POLL_H}
${define HAVE_PTHREAD_H}
${define HAVE_PWD_H}
${define HAVE_SETJMP_H}
${define HAVE_SIGNAL_H}
${define HAVE_SSL_H}
${define HAVE_STDATOMIC_H}
${define HAVE_STDBOOL_H}
${define HAVE_STDINT_H}
${define HAVE_STDLIB_H}
${define HAVE_STRINGS_H}
${define HAVE_STRING_H}
${define HAVE_STROPTS_H}
${define HAVE_SYS_FILIO_H}
${define HAVE_SYS_IOCTL_H}
${define HAVE_SYS_PARAM_H}
${define HAVE_SYS_POLL_H}
${define HAVE_SYS_RESOURCE_H}
${define HAVE_SYS_SELECT_H}
${define HAVE_SYS_SOCKET_H}
${define HAVE_SYS_SOCKIO_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TIME_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_SYS_UN_H}
${define HAVE_SYS_UTIME_H}
${define HAVE_TERMIOS_H}
${define HAVE_TERMIO_H}
${define HAVE_TIME_H}
${define HAVE_UNISTD_H}
${define HAVE_UTIME_H}
${define HAVE_WINDOWS_H}
${define HAVE_WINLDAP_H}
${define HAVE_WINSOCK2_H}
${define HAVE_WS2TCPIP_H}
${define HAVE_PROCESS_H}
${define TIME_WITH_SYS_TIME}
${define HAVE_ZLIB_H}
${define HAVE_LIBZ}

${define HAVE_BOOL_T}

${define HAVE_SELECT}
${define HAVE_ALARM}
${define HAVE_FTRUNCATE}
${define HAVE_UTIME}
${define HAVE_UTIMES}
${define HAVE_SOCKET}
${define HAVE_SIGACTION}
${define HAVE_RAND_EGD}
${define HAVE_IOCTLSOCKET}
${define HAVE_IOCTLSOCKET_FIONBIO}

${define HAVE_STRUCT_TIMEVAL}
${define HAVE_FCNTL_O_NONBLOCK}
${define HAVE_LONGLONG}

${define SIZEOF_INT}
${define SIZEOF_SIZE_T}
${define SIZEOF_CURL_OFF_T}

${define HAVE_RECV}
${define HAVE_SEND}

// wolfssl
${define USE_WOLFSSL}
${define OPENSSL_EXTRA}

// apple
${define USE_SECTRANSP}

// windows
${define USE_SCHANNEL}
${define USE_WINDOWS_SSPI}

#ifndef _WIN32

#define RECV_TYPE_ARG1 int
#define RECV_TYPE_ARG2 void *
#define RECV_TYPE_ARG3 size_t
#define RECV_TYPE_ARG4 int
#define RECV_TYPE_RETV ssize_t

#define SEND_TYPE_ARG1 int
#define SEND_QUAL_ARG2 const
#define SEND_TYPE_ARG2 void *
#define SEND_TYPE_ARG3 size_t
#define SEND_TYPE_ARG4 int
#define SEND_TYPE_RETV ssize_t

#else

#ifndef _SSIZE_T_DEFINED
#  if defined(__POCC__) || defined(__MINGW32__)
#  elif defined(_WIN64)
#    define _SSIZE_T_DEFINED
#    define ssize_t __int64
#  else
#    define _SSIZE_T_DEFINED
#    define ssize_t int
#  endif
#endif

#endif

#if defined(_MSC_VER) && !defined(_WIN32_WCE)
#  if (_MSC_VER >= 900) && (_INTEGRAL_MAX_BITS >= 64)
#    define USE_WIN32_LARGE_FILES
#  else
#    define USE_WIN32_SMALL_FILES
#  endif
#endif

#if defined(__MINGW32__) && !defined(USE_WIN32_LARGE_FILES)
#  define USE_WIN32_LARGE_FILES
#endif

#if defined(__POCC__)
#  undef USE_WIN32_LARGE_FILES
#endif

#if !defined(USE_WIN32_LARGE_FILES) && !defined(USE_WIN32_SMALL_FILES)
#  define USE_WIN32_SMALL_FILES
#endif

/* Number of bits in a file offset, on hosts where this is settable. */
#if defined(USE_WIN32_LARGE_FILES) && defined(__MINGW32__)
#  ifndef _FILE_OFFSET_BITS
#  define _FILE_OFFSET_BITS 64
#  endif
#endif

#ifdef USE_WIN32_LARGE_FILES
#define HAVE__FSEEKI64
#endif

#define PACKAGE "curl"

#endif /* HEADER_CURL_CONFIG_H */
]])
        local configs = {}
        configs["wolfssl"] = package:config("wolfssl") and "y" or "n"
        configs["winrt"] = package:config("winrt") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("curl_version()", {includes = {"curl/curl.h"}}))
    end)
