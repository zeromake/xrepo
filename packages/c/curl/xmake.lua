package("curl")
    set_homepage("https://curl.se")
    set_description("A library for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP. libcurl offers a myriad of powerful features")
    set_license("MIT")
    set_urls("https://github.com/curl/curl/releases/download/curl-$(version).tar.bz2", {version = function (version)
        return version:gsub("%.", "_") .. "/curl-" .. version
    end})

    add_versions("8.6.0", "b4785f2d8877fa92c0e45d7155cf8cc6750dbda961f4b1a45bcbec990cf2fa9b")
    add_versions("8.4.0", "e5250581a9c032b1b6ed3cf2f9c114c811fc41881069e9892d115cc73f9e88c6")
    add_versions("7.86.0", "f5ca69db03eea17fa8705bdfb1a9f58d76a46c9010518109bb38f313137e0a28")
    add_versions("7.85.0", "21a7e83628ee96164ac2b36ff6bf99d467c7b0b621c1f7e317d8f0d96011539c")

    add_configs("winrt", {description = "Support winrt", default = false, type = "boolean"})
    add_configs("wolfssl", {description = "use wolfssl", default = false, type = "boolean"})
    add_configs("libressl", {description = "use libressl", default = false, type = "boolean"})
    add_configs("brotli", {description = "use brotli", default = false, type = "boolean"})
    add_configs("zstd", {description = "use zstd", default = false, type = "boolean"})
    add_configs("ssh2", {description = "use ssh2", default = false, type = "boolean"})
    add_configs("ngtcp2", {description = "use ngtcp2", default = false, type = "boolean"})
    add_configs("nghttp2", {description = "use nghttp2", default = false, type = "boolean"})
    add_configs("nghttp3", {description = "use nghttp3", default = false, type = "boolean"})
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})

    add_deps("zlib")
    on_load(function (package)
        if package:is_plat("windows", "mingw") then
            package:add("syslinks", "ws2_32", "crypt32", "bcrypt", "advapi32", "normaliz")
            if not package:config("winrt") then
                package:add("syslinks", "wldap32")
            end
        elseif package:is_plat("macosx", "iphoneos") then
            package:add("frameworks", "CoreFoundation", "Security", "SystemConfiguration")
        end
        if package:config("libressl") then
            package:add("deps", "libressl")
        elseif package:config("wolfssl") then
            package:add("deps", "wolfssl")
        end
        if package:config("brotli") then
            package:add("deps", "brotli")
        end
        if package:config("zstd") then
            package:add("deps", "zstd")
        end
        if package:config("ssh2") then
            package:add("deps", "ssh2")
        end
        if package:config("ngtcp2") then
            package:add("deps", "ngtcp2")
        end
        if package:config("nghttp2") then
            package:add("deps", "nghttp2")
        end
        if package:config("nghttp3") then
            package:add("deps", "nghttp3")
        end
        if package:config("shared") ~= true then
            package:add("defines", "BUILDING_LIBCURL", "CURL_STATICLIB")
        else
            package:add("defines", "BUILDING_LIBCURL")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        -- if is_plat("windows", "mingw") then
        --     os.cp("lib/config-win32.h", "lib/curl_config.h")
        -- end
        local transforme_configfile = function (input, output, extra)
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#undef ") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}\n"
                elseif line:startswith("#  undef ") then
                    local name = line:split("%s+")[3]
                    line = "${define "..name.."}\n"
                end
                out:write(line)
                out:write("\n")
            end
            if extra then
                out:write(extra)
            end
            out:close()
        end
        transforme_configfile("lib/curl_config.h.in", "curl_config.h.in", [[
#if defined(BUILDING_CURL_CLI) && defined(BUILDING_LIBCURL)
#define curlx_dynbuf dynbuf
#define curlx_dyn_init Curl_dyn_init
#define curlx_dyn_add Curl_dyn_add
#define curlx_dyn_addn Curl_dyn_addn
#define curlx_dyn_addf Curl_dyn_addf
#define curlx_dyn_vaddf Curl_dyn_vaddf
#define curlx_dyn_free Curl_dyn_free
#define curlx_dyn_ptr Curl_dyn_ptr
#define curlx_dyn_uptr Curl_dyn_uptr
#define curlx_dyn_len Curl_dyn_len
#define curlx_dyn_reset Curl_dyn_reset
#define curlx_dyn_tail Curl_dyn_tail
#define curlx_dyn_setlen Curl_dyn_setlen
#define curlx_base64_encode Curl_base64_encode
#define curlx_base64url_encode Curl_base64url_encode
#define curlx_base64_decode Curl_base64_decode
#endif
]])
        io.writefile("lib/curl_config.h.in", [[
/***************************************************************************
*                                  _   _ ____  _
*  Project                     ___| | | |  _ \| |
*                             / __| | | | |_) | |
*                            | (__| |_| |  _ <| |___
*                             \___|\___/|_| \_\_____|
*
* Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
*
* This software is licensed as described in the file COPYING, which
* you should have received as part of this distribution. The terms
* are also available at https://curl.se/docs/copyright.html.
*
* You may opt to use, copy, modify, merge, publish, distribute and/or sell
* copies of the Software, and permit persons to whom the Software is
* furnished to do so, under the terms of the COPYING file.
*
* This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
* KIND, either express or implied.
*
* SPDX-License-Identifier: curl
*
***************************************************************************/
/* lib/curl_config.h.in.  Generated somehow by cmake.  */

/* Location of default ca bundle */
#define CURL_CA_BUNDLE "/etc/ssl/cert.pem"

/* define "1" to use built-in ca store of TLS backend */
/* #undef CURL_CA_FALLBACK */

/* Location of default ca path */
#define CURL_CA_PATH "/etc/ssl/certs"

/* Default SSL backend */
/* #undef CURL_DEFAULT_SSL_BACKEND */

/* disables alt-svc */
/* #undef CURL_DISABLE_ALTSVC */

/* disables cookies support */
/* #undef CURL_DISABLE_COOKIES */

/* disables Basic authentication */
/* #undef CURL_DISABLE_BASIC_AUTH */

/* disables Bearer authentication */
/* #undef CURL_DISABLE_BEARER_AUTH */

/* disables Digest authentication */
/* #undef CURL_DISABLE_DIGEST_AUTH */

/* disables Kerberos authentication */
/* #undef CURL_DISABLE_KERBEROS_AUTH */

/* disables negotiate authentication */
/* #undef CURL_DISABLE_NEGOTIATE_AUTH */

/* disables AWS-SIG4 */
/* #undef CURL_DISABLE_AWS */

/* disables DICT */
/* #undef CURL_DISABLE_DICT */

/* disables DNS-over-HTTPS */
/* #undef CURL_DISABLE_DOH */

/* disables FILE */
/* #undef CURL_DISABLE_FILE */

/* disables form api */
/* #undef CURL_DISABLE_FORM_API */

/* disables FTP */
/* #undef CURL_DISABLE_FTP */

/* disables curl_easy_options API for existing options to curl_easy_setopt */
/* #undef CURL_DISABLE_GETOPTIONS */

/* disables GOPHER */
/* #undef CURL_DISABLE_GOPHER */

/* disables headers-api support */
/* #undef CURL_DISABLE_HEADERS_API */

/* disables HSTS support */
/* #undef CURL_DISABLE_HSTS */

/* disables HTTP */
/* #undef CURL_DISABLE_HTTP */

/* disables IMAP */
/* #undef CURL_DISABLE_IMAP */

/* disables LDAP */
#define CURL_DISABLE_LDAP

/* disables LDAPS */
/* #undef CURL_DISABLE_LDAPS */

/* disables --libcurl option from the curl tool */
/* #undef CURL_DISABLE_LIBCURL_OPTION */

/* disables MIME support */
/* #undef CURL_DISABLE_MIME */

/* disables local binding support */
/* #undef CURL_DISABLE_BINDLOCAL */

/* disables MQTT */
/* #undef CURL_DISABLE_MQTT */

/* disables netrc parser */
/* #undef CURL_DISABLE_NETRC */

/* disables NTLM support */
/* #undef CURL_DISABLE_NTLM */

/* disables date parsing */
/* #undef CURL_DISABLE_PARSEDATE */

/* disables POP3 */
/* #undef CURL_DISABLE_POP3 */

/* disables built-in progress meter */
/* #undef CURL_DISABLE_PROGRESS_METER */

/* disables proxies */
/* #undef CURL_DISABLE_PROXY */

/* disables RTSP */
/* #undef CURL_DISABLE_RTSP */

/* disables SMB */
/* #undef CURL_DISABLE_SMB */

/* disables SMTP */
/* #undef CURL_DISABLE_SMTP */

/* disables use of socketpair for curl_multi_poll */
/* #undef CURL_DISABLE_SOCKETPAIR */

/* disables TELNET */
/* #undef CURL_DISABLE_TELNET */

/* disables TFTP */
/* #undef CURL_DISABLE_TFTP */

/* disables verbose strings */
/* #undef CURL_DISABLE_VERBOSE_STRINGS */

/* to make a symbol visible */
#define CURL_EXTERN_SYMBOL __attribute__ ((__visibility__ ("default")))
/* Ensure using CURL_EXTERN_SYMBOL is possible */
#ifndef CURL_EXTERN_SYMBOL
#define CURL_EXTERN_SYMBOL
#endif

/* Allow SMB to work on Windows */
/* #undef USE_WIN32_CRYPTO */

/* Use Windows LDAP implementation */
/* #undef USE_WIN32_LDAP */

/* Define if you want to enable IPv6 support */
#define ENABLE_IPV6 1

/* Define to 1 if you have the alarm function. */
#define HAVE_ALARM 1

/* Define to 1 if you have the arc4random function. */
#define HAVE_ARC4RANDOM 1

/* Define to 1 if you have the <arpa/inet.h> header file. */
#define HAVE_ARPA_INET_H 1

/* Define to 1 if you have _Atomic support. */
#define HAVE_ATOMIC 1

/* Define to 1 if you have the `fnmatch' function. */
#define HAVE_FNMATCH 1

/* Define to 1 if you have the `basename' function. */
#define HAVE_BASENAME 1

/* Define to 1 if bool is an available type. */
#define HAVE_BOOL_T 1

/* Define to 1 if you have the __builtin_available function. */
#define HAVE_BUILTIN_AVAILABLE 1

/* Define to 1 if you have the clock_gettime function and monotonic timer. */
#define HAVE_CLOCK_GETTIME_MONOTONIC 1

/* Define to 1 if you have the clock_gettime function and raw monotonic timer.
    */
#define HAVE_CLOCK_GETTIME_MONOTONIC_RAW 1

/* Define to 1 if you have the `closesocket' function. */
/* #undef HAVE_CLOSESOCKET */

/* Define to 1 if you have the fcntl function. */
#define HAVE_FCNTL 1

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have a working fcntl O_NONBLOCK function. */
#define HAVE_FCNTL_O_NONBLOCK 1

/* Define to 1 if you have the freeaddrinfo function. */
#define HAVE_FREEADDRINFO 1

/* Define to 1 if you have the fseeko function. */
#define HAVE_FSEEKO 1

/* Define to 1 if you have the fseeko declaration. */
#define HAVE_DECL_FSEEKO 1

/* Define to 1 if you have the _fseeki64 function. */
/* #undef HAVE__FSEEKI64 */

/* Define to 1 if you have the ftruncate function. */
#define HAVE_FTRUNCATE 1

/* Define to 1 if you have a working getaddrinfo function. */
#define HAVE_GETADDRINFO 1

/* Define to 1 if the getaddrinfo function is threadsafe. */
#define HAVE_GETADDRINFO_THREADSAFE 1

/* Define to 1 if you have the `geteuid' function. */
#define HAVE_GETEUID 1

/* Define to 1 if you have the `getppid' function. */
#define HAVE_GETPPID 1

/* Define to 1 if you have the gethostbyname_r function. */
/* #undef HAVE_GETHOSTBYNAME_R */

/* gethostbyname_r() takes 3 args */
/* #undef HAVE_GETHOSTBYNAME_R_3 */

/* gethostbyname_r() takes 5 args */
/* #undef HAVE_GETHOSTBYNAME_R_5 */

/* gethostbyname_r() takes 6 args */
/* #undef HAVE_GETHOSTBYNAME_R_6 */

/* Define to 1 if you have the gethostname function. */
#define HAVE_GETHOSTNAME 1

/* Define to 1 if you have a working getifaddrs function. */
#define HAVE_GETIFADDRS 1

/* Define to 1 if you have the `getpass_r' function. */
/* #undef HAVE_GETPASS_R */

/* Define to 1 if you have the `getpeername' function. */
#define HAVE_GETPEERNAME 1

/* Define to 1 if you have the `getsockname' function. */
#define HAVE_GETSOCKNAME 1

/* Define to 1 if you have the `if_nametoindex' function. */
#define HAVE_IF_NAMETOINDEX 1

/* Define to 1 if you have the `getpwuid' function. */
#define HAVE_GETPWUID 1

/* Define to 1 if you have the `getpwuid_r' function. */
#define HAVE_GETPWUID_R 1

/* Define to 1 if you have the `getrlimit' function. */
#define HAVE_GETRLIMIT 1

/* Define to 1 if you have the `gettimeofday' function. */
#define HAVE_GETTIMEOFDAY 1

/* Define to 1 if you have a working glibc-style strerror_r function. */
/* #undef HAVE_GLIBC_STRERROR_R */

/* Define to 1 if you have a working gmtime_r function. */
#define HAVE_GMTIME_R 1

/* if you have the gssapi libraries */
/* #undef HAVE_GSSAPI */

/* Define to 1 if you have the <gssapi/gssapi_generic.h> header file. */
/* #undef HAVE_GSSAPI_GSSAPI_GENERIC_H */

/* Define to 1 if you have the <gssapi/gssapi.h> header file. */
/* #undef HAVE_GSSAPI_GSSAPI_H */

/* Define to 1 if you have the <gssapi/gssapi_krb5.h> header file. */
/* #undef HAVE_GSSAPI_GSSAPI_KRB5_H */

/* if you have the GNU gssapi libraries */
/* #undef HAVE_GSSGNU */

/* Define to 1 if you have the `idna_strerror' function. */
/* #undef HAVE_IDNA_STRERROR */

/* Define to 1 if you have the <ifaddrs.h> header file. */
#define HAVE_IFADDRS_H 1

/* Define to 1 if you have a IPv6 capable working inet_ntop function. */
#define HAVE_INET_NTOP 1

/* Define to 1 if you have a IPv6 capable working inet_pton function. */
#define HAVE_INET_PTON 1

/* Define to 1 if symbol `sa_family_t' exists */
#define HAVE_SA_FAMILY_T 1

/* Define to 1 if symbol `ADDRESS_FAMILY' exists */
/* #undef HAVE_ADDRESS_FAMILY */

/* Define to 1 if you have the ioctlsocket function. */
/* #undef HAVE_IOCTLSOCKET */

/* Define to 1 if you have the IoctlSocket camel case function. */
/* #undef HAVE_IOCTLSOCKET_CAMEL */

/* Define to 1 if you have a working IoctlSocket camel case FIONBIO function.
    */
/* #undef HAVE_IOCTLSOCKET_CAMEL_FIONBIO */

/* Define to 1 if you have a working ioctlsocket FIONBIO function. */
/* #undef HAVE_IOCTLSOCKET_FIONBIO */

/* Define to 1 if you have a working ioctl FIONBIO function. */
#define HAVE_IOCTL_FIONBIO 1

/* Define to 1 if you have a working ioctl SIOCGIFADDR function. */
#define HAVE_IOCTL_SIOCGIFADDR 1

/* Define to 1 if you have the <io.h> header file. */
/* #undef HAVE_IO_H */

/* Define to 1 if you have the lber.h header file. */
#define HAVE_LBER_H 1

/* Define to 1 if you have the ldap.h header file. */
#define HAVE_LDAP_H 1

/* Use LDAPS implementation */
#define HAVE_LDAP_SSL 1

/* Define to 1 if you have the ldap_ssl.h header file. */
/* #undef HAVE_LDAP_SSL_H */

/* Define to 1 if you have the `ldap_url_parse' function. */
#define HAVE_LDAP_URL_PARSE 1

/* Define to 1 if you have the <libgen.h> header file. */
#define HAVE_LIBGEN_H 1

/* Define to 1 if you have the `idn2' library (-lidn2). */
/* #undef HAVE_LIBIDN2 */

/* Define to 1 if you have the idn2.h header file. */
/* #undef HAVE_IDN2_H */

/* Define to 1 if you have the `socket' library (-lsocket). */
/* #undef HAVE_LIBSOCKET */

/* Define to 1 if you have the `ssh2' library (-lssh2). */
/* #undef HAVE_LIBSSH2 */

/* if zlib is available */
#define HAVE_LIBZ 1

/* if brotli is available */
/* #undef HAVE_BROTLI */

/* if zstd is available */
/* #undef HAVE_ZSTD */

/* Define to 1 if you have the <locale.h> header file. */
#define HAVE_LOCALE_H 1

/* Define to 1 if the compiler supports the 'long long' data type. */
#define HAVE_LONGLONG 1

/* Define to 1 if you have the 'suseconds_t' data type. */
#define HAVE_SUSECONDS_T 1

/* Define to 1 if you have the MSG_NOSIGNAL flag. */
#define HAVE_MSG_NOSIGNAL 1

/* Define to 1 if you have the <netdb.h> header file. */
#define HAVE_NETDB_H 1

/* Define to 1 if you have the <netinet/in.h> header file. */
#define HAVE_NETINET_IN_H 1

/* Define to 1 if you have the <netinet/tcp.h> header file. */
#define HAVE_NETINET_TCP_H 1

/* Define to 1 if you have the <netinet/udp.h> header file. */
#define HAVE_NETINET_UDP_H 1

/* Define to 1 if you have the <linux/tcp.h> header file. */
/* #undef HAVE_LINUX_TCP_H */

/* Define to 1 if you have the <net/if.h> header file. */
#define HAVE_NET_IF_H 1

/* if you have an old MIT gssapi library, lacking GSS_C_NT_HOSTBASED_SERVICE */
/* #undef HAVE_OLD_GSSMIT */

/* Define to 1 if you have the `pipe' function. */
#define HAVE_PIPE 1

/* If you have a fine poll */
/* #undef HAVE_POLL_FINE */

/* Define to 1 if you have the <poll.h> header file. */
#define HAVE_POLL_H 1

/* Define to 1 if you have a working POSIX-style strerror_r function. */
#define HAVE_POSIX_STRERROR_R 1

/* Define to 1 if you have the <pthread.h> header file */
#define HAVE_PTHREAD_H 1

/* Define to 1 if you have the <pwd.h> header file. */
#define HAVE_PWD_H 1

/* Define to 1 if OpenSSL has the `SSL_set0_wbio` function. */
/* #undef HAVE_SSL_SET0_WBIO */

/* Define to 1 if you have the recv function. */
#define HAVE_RECV 1

/* Define to 1 if you have the select function. */
#define HAVE_SELECT 1

/* Define to 1 if you have the sched_yield function. */
#define HAVE_SCHED_YIELD 1

/* Define to 1 if you have the send function. */
#define HAVE_SEND 1

/* Define to 1 if you have the sendmsg function. */
#define HAVE_SENDMSG 1

/* Define to 1 if you have the 'fsetxattr' function. */
#define HAVE_FSETXATTR 1

/* fsetxattr() takes 5 args */
/* #undef HAVE_FSETXATTR_5 */

/* fsetxattr() takes 6 args */
#define HAVE_FSETXATTR_6 1

/* Define to 1 if you have the `setlocale' function. */
#define HAVE_SETLOCALE 1

/* Define to 1 if you have the `setmode' function. */
#define HAVE_SETMODE 1

/* Define to 1 if you have the `setrlimit' function. */
#define HAVE_SETRLIMIT 1

/* Define to 1 if you have a working setsockopt SO_NONBLOCK function. */
/* #undef HAVE_SETSOCKOPT_SO_NONBLOCK */

/* Define to 1 if you have the sigaction function. */
#define HAVE_SIGACTION 1

/* Define to 1 if you have the siginterrupt function. */
#define HAVE_SIGINTERRUPT 1

/* Define to 1 if you have the signal function. */
#define HAVE_SIGNAL 1

/* Define to 1 if you have the sigsetjmp function or macro. */
#define HAVE_SIGSETJMP 1

/* Define to 1 if you have the `snprintf' function. */
#define HAVE_SNPRINTF 1

/* Define to 1 if struct sockaddr_in6 has the sin6_scope_id member */
#define HAVE_SOCKADDR_IN6_SIN6_SCOPE_ID 1

/* Define to 1 if you have the `socket' function. */
#define HAVE_SOCKET 1

/* Define to 1 if you have the socketpair function. */
#define HAVE_SOCKETPAIR 1

/* Define to 1 if you have the <stdatomic.h> header file. */
#define HAVE_STDATOMIC_H 1

/* Define to 1 if you have the <stdbool.h> header file. */
#define HAVE_STDBOOL_H 1

/* Define to 1 if you have the strcasecmp function. */
#define HAVE_STRCASECMP 1

/* Define to 1 if you have the strcmpi function. */
/* #undef HAVE_STRCMPI */

/* Define to 1 if you have the strdup function. */
#define HAVE_STRDUP 1

/* Define to 1 if you have the strerror_r function. */
#define HAVE_STRERROR_R 1

/* Define to 1 if you have the stricmp function. */
/* #undef HAVE_STRICMP */

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <stropts.h> header file. */
/* #undef HAVE_STROPTS_H */

/* Define to 1 if you have the strtok_r function. */
#define HAVE_STRTOK_R 1

/* Define to 1 if you have the strtoll function. */
#define HAVE_STRTOLL 1

/* Define to 1 if you have the memrchr function. */
/* #undef HAVE_MEMRCHR */

/* if struct sockaddr_storage is defined */
#define HAVE_STRUCT_SOCKADDR_STORAGE 1

/* Define to 1 if you have the timeval struct. */
#define HAVE_STRUCT_TIMEVAL 1

/* Define to 1 if you have the <sys/filio.h> header file. */
#define HAVE_SYS_FILIO_H 1

/* Define to 1 if you have the <sys/wait.h> header file. */
#define HAVE_SYS_WAIT_H 1

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#define HAVE_SYS_IOCTL_H 1

/* Define to 1 if you have the <sys/param.h> header file. */
#define HAVE_SYS_PARAM_H 1

/* Define to 1 if you have the <sys/poll.h> header file. */
#define HAVE_SYS_POLL_H 1

/* Define to 1 if you have the <sys/resource.h> header file. */
#define HAVE_SYS_RESOURCE_H 1

/* Define to 1 if you have the <sys/select.h> header file. */
#define HAVE_SYS_SELECT_H 1

/* Define to 1 if you have the <sys/socket.h> header file. */
#define HAVE_SYS_SOCKET_H 1

/* Define to 1 if you have the <sys/sockio.h> header file. */
#define HAVE_SYS_SOCKIO_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <sys/un.h> header file. */
#define HAVE_SYS_UN_H 1

/* Define to 1 if you have the <sys/utime.h> header file. */
/* #undef HAVE_SYS_UTIME_H */

/* Define to 1 if you have the <termios.h> header file. */
#define HAVE_TERMIOS_H 1

/* Define to 1 if you have the <termio.h> header file. */
/* #undef HAVE_TERMIO_H */

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the `utime' function. */
#define HAVE_UTIME 1

/* Define to 1 if you have the `utimes' function. */
#define HAVE_UTIMES 1

/* Define to 1 if you have the <utime.h> header file. */
#define HAVE_UTIME_H 1

/* Define this symbol if your OS supports changing the contents of argv */
#define HAVE_WRITABLE_ARGV 1

/* Define to 1 if you need the lber.h header file even with ldap.h */
/* #undef NEED_LBER_H */

/* Define to 1 if you need the malloc.h header file even with stdlib.h */
/* #undef NEED_MALLOC_H */

/* Define to 1 if _REENTRANT preprocessor symbol must be defined. */
/* #undef NEED_REENTRANT */

/* cpu-machine-OS */
#define OS "Darwin"

/* Name of package */
/* #undef PACKAGE */

/* Define to the address where bug reports for this package should be sent. */
/* #undef PACKAGE_BUGREPORT */

/* Define to the full name of this package. */
/* #undef PACKAGE_NAME */

/* Define to the full name and version of this package. */
/* #undef PACKAGE_STRING */

/* Define to the one symbol short name of this package. */
/* #undef PACKAGE_TARNAME */

/* Define to the version of this package. */
/* #undef PACKAGE_VERSION */

/* a suitable file to read random data from */
#define RANDOM_FILE "/dev/urandom"

/*
Note: SIZEOF_* variables are fetched with CMake through check_type_size().
As per CMake documentation on CheckTypeSize, C preprocessor code is
generated by CMake into SIZEOF_*_CODE. This is what we use in the
following statements.

Reference: https://cmake.org/cmake/help/latest/module/CheckTypeSize.html
*/

/* The size of `int', as computed by sizeof. */
#define SIZEOF_INT 4

/* The size of `long', as computed by sizeof. */
#define SIZEOF_LONG 8

/* The size of `long long', as computed by sizeof. */
#define SIZEOF_LONG_LONG 8

/* The size of `off_t', as computed by sizeof. */
#define SIZEOF_OFF_T 8

/* The size of `curl_off_t', as computed by sizeof. */
#define SIZEOF_CURL_OFF_T 8

/* The size of `curl_socket_t', as computed by sizeof. */
#define SIZEOF_CURL_SOCKET_T 4

/* The size of `size_t', as computed by sizeof. */
#define SIZEOF_SIZE_T 8

/* The size of `time_t', as computed by sizeof. */
#define SIZEOF_TIME_T 8

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define if you want to enable c-ares support */
/* #undef USE_ARES */

/* Define if you want to enable POSIX threaded DNS lookup */
#define USE_THREADS_POSIX 1

/* Define if you want to enable WIN32 threaded DNS lookup */
/* #undef USE_THREADS_WIN32 */

/* if Secure Transport is enabled */
/* #undef USE_SECTRANSP */

/* if mbedTLS is enabled */
/* #undef USE_MBEDTLS */

/* if BearSSL is enabled */
/* #undef USE_BEARSSL */

/* if WolfSSL is enabled */
/* #undef USE_WOLFSSL */

/* if libSSH is in use */
/* #undef USE_LIBSSH */

/* if libSSH2 is in use */
#define USE_LIBSSH2 1

/* if libPSL is in use */
/* #undef USE_LIBPSL */

/* if you want to use OpenLDAP code instead of legacy ldap implementation */
/* #undef USE_OPENLDAP */

/* if OpenSSL is in use */
#define USE_OPENSSL

/* Define to 1 if you don't want the OpenSSL configuration to be loaded
    automatically */
/* #undef CURL_DISABLE_OPENSSL_AUTO_LOAD_CONFIG */

/* to enable NGHTTP2  */
#define USE_NGHTTP2 1

/* to enable NGTCP2 */
#define USE_NGTCP2 1

/* to enable NGHTTP3  */
#define USE_NGHTTP3 1

/* to enable quiche */
/* #undef USE_QUICHE */

/* Define to 1 if you have the quiche_conn_set_qlog_fd function. */
/* #undef HAVE_QUICHE_CONN_SET_QLOG_FD */

/* to enable msh3 */
/* #undef USE_MSH3 */

/* if Unix domain sockets are enabled  */
#define USE_UNIX_SOCKETS 1

/* Define to 1 if you are building a Windows target with large file support. */
/* #undef USE_WIN32_LARGE_FILES */

/* to enable SSPI support */
/* #undef USE_WINDOWS_SSPI */

/* to enable Windows SSL  */
/* #undef USE_SCHANNEL */

/* enable multiple SSL backends */
/* #undef CURL_WITH_MULTI_SSL */

/* Version number of package */
/* #undef VERSION */

/* Define to 1 if OS is AIX. */
#ifndef _ALL_SOURCE
#  undef _ALL_SOURCE
#endif

/* Number of bits in a file offset, on hosts where this is settable. */
#define _FILE_OFFSET_BITS 64

/* Define for large files, on AIX-style hosts. */
/* #undef _LARGE_FILES */

/* define this if you need it to compile thread-safe code */
/* #undef _THREAD_SAFE */

/* Define to empty if `const' does not conform to ANSI C. */
/* #undef const */

/* Type to use in place of in_addr_t when system does not provide it. */
/* #undef in_addr_t */

/* Define to `__inline__' or `__inline' if that's what the C compiler
    calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
#undef inline
#endif

/* Define to `unsigned int' if <sys/types.h> does not define. */
/* #undef size_t */

/* the signed version of size_t */
/* #undef ssize_t */

/* Define to 1 if you have the mach_absolute_time function. */
#define HAVE_MACH_ABSOLUTE_TIME 1

/* to enable Windows IDN */
/* #undef USE_WIN32_IDN */

/* Define to 1 to enable websocket support. */
/* #undef USE_WEBSOCKETS */

/* Define to 1 if OpenSSL has the SSL_CTX_set_srp_username function. */
/* #undef HAVE_OPENSSL_SRP */
           
]])
        local configs = {}
        configs["wolfssl"] = package:config("wolfssl") and "y" or "n"
        configs["winrt"] = package:config("winrt") and "y" or "n"
        configs["libressl"] = package:config("libressl") and "y" or "n"
        configs["brotli"] = package:config("brotli") and "y" or "n"
        configs["zstd"] = package:config("zstd") and "y" or "n"
        configs["ssh2"] = package:config("ssh2") and "y" or "n"
        configs["ngtcp2"] = package:config("ngtcp2") and "y" or "n"
        configs["nghttp2"] = package:config("nghttp2") and "y" or "n"
        configs["nghttp3"] = package:config("nghttp3") and "y" or "n"
        configs["cli"] = package:config("cli") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
        import("net.http")
        print("https://curl.se/ca/cacert.pem -> bin/curl-ca-bundle.crt")
        http.download("https://curl.se/ca/cacert.pem", path.join(package:installdir("bin"), "curl-ca-bundle.crt"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("curl_version()", {includes = {"curl/curl.h"}}))
    end)
