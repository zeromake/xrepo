local options = {}

package("curl")
    set_homepage("https://curl.se")
    set_description("A library for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP. libcurl offers a myriad of powerful features")
    set_license("MIT")
    set_urls("https://github.com/curl/curl/releases/download/curl-$(version).tar.bz2", {version = function (version)
        return version:gsub("%.", "_") .. "/curl-" .. version
    end})

    add_versions("7.86.0", "f5ca69db03eea17fa8705bdfb1a9f58d76a46c9010518109bb38f313137e0a28")
    add_versions("7.85.0", "21a7e83628ee96164ac2b36ff6bf99d467c7b0b621c1f7e317d8f0d96011539c")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_deps("wolfssl", "zlib")
    add_includedirs("include")

    add_defines("BUILDING_LIBCURL")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
        if package:config("shared") ~= true then
            package:add("defines", "CURL_STATICLIB")
        end
    end)

    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "wldap32", "crypt32", "bcrypt")
    end

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        if package:is_plat("windows", "mingw") then
            os.cp("lib/config-win32.h", "lib/curl_config.h")
        elseif package:is_plat("macosx") then
            os.cp(path.join(os.scriptdir(), "port", "curl_config.h"), "lib/curl_config.h")
        else
            io.writefile("curl_config.h.in", [[
#ifndef HEADER_CURL_CONFIG_H
#define HEADER_CURL_CONFIG_H

${define OS}
${define CURL_DISABLE_LDAP}

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

#define HAVE_RECV 1
#define HAVE_SEND 1

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

#endif /* HEADER_CURL_CONFIG_H */
        ]])
        end

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

    on_test(function (package)
        assert(package:has_cfuncs("curl_version()", {includes = {"curl/curl.h"}}))
    end)
