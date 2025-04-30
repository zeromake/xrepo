if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
    includes("check_csnippets.lua")
    includes("check_cfuncs.lua")
    includes("check_ctypes.lua")
end
add_rules("mode.debug", "mode.release")

option("winrt")
    set_default(false)
    set_showmenu(true)
option_end()

option("wolfssl")
    set_default(false)
    set_showmenu(true)
option_end()

option("httponly")
    set_default(false)
    set_showmenu(true)
option_end()

option("libressl")
    set_default(false)
    set_showmenu(true)
option_end()

option("brotli")
    set_default(false)
    set_showmenu(true)
option_end()

option("zstd")
    set_default(false)
    set_showmenu(true)
option_end()

option("ssh2")
    set_default(false)
    set_showmenu(true)
option_end()

option("ngtcp2")
    set_default(false)
    set_showmenu(true)
option_end()

option("nghttp2")
    set_default(false)
    set_showmenu(true)
option_end()

option("nghttp3")
    set_default(false)
    set_showmenu(true)
option_end()

option("cli")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("zlib")

if get_config("wolfssl") then
    add_requires("wolfssl")
end

if get_config("libressl") then
    add_requires("libressl")
end

if get_config("brotli") then
    add_requires("brotli")
end

if get_config("zstd") then
    add_requires("zstd")
end

if get_config("ssh2") then
    add_requires("ssh2")
end


if get_config("ngtcp2") then
    add_requires("ngtcp2")
end

if get_config("nghttp2") then
    add_requires("nghttp2")
end

if get_config("nghttp3") then
    add_requires("nghttp3")
end

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

function configvar_check_csymbol_exists(define_name, var_name, opt)
    configvar_check_csnippets(define_name, 'void* a =(void*)('..var_name..');', opt)
end

local configvar_check_sizeof = configvar_check_sizeof or function(define_name, type_name, opt)
    opt = opt or {}
    opt.output = true
    opt.number = true
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', opt)
end

function configvar_check_has_member(define_name, type_name, member, opt)
    configvar_check_csnippets(define_name, format([[
void has_member() {
    %s a;
    a.%s;
}]], type_name, member), opt)
end

set_configdir("$(buildir)/config")
add_includedirs("$(buildir)/config")
add_configfiles("curl_config.h.in")

local cxflags = {}
if is_plat("windows") then
    table.insert(cxflags, "/I "..path.absolute(os.scriptdir()))
else
    table.insert(cxflags, "-I "..path.absolute(os.scriptdir()))
end

configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
configvar_check_cincludes("HAVE_ARPA_TFTP_H", "arpa/tftp.h")
configvar_check_cincludes("HAVE_ASSERT_H", "assert.h")
configvar_check_cincludes("HAVE_ERRNO_H", "errno.h")
configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
configvar_check_cincludes("HAVE_GSSAPI_GSSAPI_GENERIC_H", "gssapi/gssapi_generic.h")
configvar_check_cincludes("HAVE_GSSAPI_GSSAPI_H", "gssapi/gssapi.h")
configvar_check_cincludes("HAVE_GSSAPI_GSSAPI_KRB5_H", "gssapi/gssapi_krb5.h")
configvar_check_cincludes("HAVE_IFADDRS_H", "ifaddrs.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_IO_H", "io.h")
configvar_check_cincludes("HAVE_LBER_H", "lber.h")
configvar_check_cincludes("HAVE_LDAP_H", "ldap.h")
configvar_check_cincludes("HAVE_LDAP_SSL_H", "ldap_ssl.h")
configvar_check_cincludes("HAVE_LIBGEN_H", "libgen.h")
configvar_check_cincludes("HAVE_IDN2_H", "idn2.h")
configvar_check_cincludes("HAVE_LIBPSL_H", "libpsl.h")
configvar_check_cincludes("HAVE_LIBSSH2_H", "libssh2.h")
configvar_check_cincludes("HAVE_LIBSSH_LIBSSH_H", "libssh/libssh.h")
configvar_check_cincludes("HAVE_LOCALE_H", "locale.h")
configvar_check_cincludes("HAVE_NETDB_H", "netdb.h")
configvar_check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")
configvar_check_cincludes("HAVE_NETINET_TCP_H", "netinet/tcp.h")
configvar_check_cincludes("HAVE_LINUX_TCP_H", "linux/tcp.h")
configvar_check_cincludes("HAVE_NET_IF_H", "net/if.h")
configvar_check_cincludes("HAVE_NETINET_UDP_H", "netinet/udp.h")
configvar_check_cincludes("HAVE_POLL_H", "poll.h")
configvar_check_cincludes("HAVE_PTHREAD_H", "pthread.h")
configvar_check_cincludes("HAVE_PWD_H", "pwd.h")
configvar_check_cincludes("HAVE_SETJMP_H", "setjmp.h")
configvar_check_cincludes("HAVE_SIGNAL_H", "signal.h")
configvar_check_cincludes("HAVE_SSL_H", "ssl.h")
configvar_check_cincludes("HAVE_STDATOMIC_H", "stdatomic.h")
configvar_check_cincludes("HAVE_STDBOOL_H", "stdbool.h")
configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
configvar_check_cincludes("HAVE_STRING_H", "string.h")
configvar_check_cincludes("HAVE_STROPTS_H", "stropts.h")
configvar_check_cincludes("HAVE_SYS_FILIO_H", "sys/filio.h")
configvar_check_cincludes("HAVE_SYS_WAIT_H", "sys/wait.h")
configvar_check_cincludes("HAVE_SYS_IOCTL_H", "sys/ioctl.h")
configvar_check_cincludes("HAVE_SYS_PARAM_H", "sys/param.h")
configvar_check_cincludes("HAVE_SYS_POLL_H", "sys/poll.h")
configvar_check_cincludes("HAVE_SYS_RESOURCE_H", "sys/resource.h")
configvar_check_cincludes("HAVE_SYS_SELECT_H", "sys/select.h")
configvar_check_cincludes("HAVE_SYS_SOCKET_H", "sys/socket.h")
configvar_check_cincludes("HAVE_SYS_SOCKIO_H", "sys/sockio.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
configvar_check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
configvar_check_cincludes("HAVE_SYS_UN_H", "sys/un.h")
configvar_check_cincludes("HAVE_SYS_UTIME_H", "sys/utime.h")
configvar_check_cincludes("HAVE_TERMIOS_H", "termios.h")
configvar_check_cincludes("HAVE_TERMIO_H", "termio.h")
configvar_check_cincludes("HAVE_TIME_H", "time.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cincludes("HAVE_UTIME_H", "utime.h")
configvar_check_cincludes("HAVE_PROCESS_H", "process.h")
-- configvar_check_cincludes("TIME_WITH_SYS_TIME", {"sys/time.h", "time.h"})

configvar_check_cfuncs("HAVE_ALARM", "alarm", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_FTRUNCATE", "ftruncate", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_UTIME", "utime", {includes={"utime.h"}})
configvar_check_cfuncs("HAVE_UTIMES", "utimes", {includes={"sys/time.h"}})
configvar_check_cfuncs("HAVE_SIGACTION", "sigaction", {includes={"signal.h"}})
configvar_check_cfuncs("HAVE_SIGACTION", "sigaction", {includes={"signal.h"}})
configvar_check_cfuncs("HAVE_RAND_EGD", "RAND_egd", {includes={"openssl/rand.h"}})
configvar_check_cfuncs("HAVE_SNPRINTF", "snprintf", {includes={"stdio.h"}})
configvar_check_cfuncs("HAVE_SIGNAL", "signal", {includes={"signal.h"}})
configvar_check_cfuncs("HAVE_SIGINTERRUPT", "siginterrupt", {includes={"signal.h"}})
configvar_check_cfuncs("HAVE_STRTOLL", "strtoll", {includes={"stdlib.h"}})
configvar_check_cfuncs("HAVE_STRICMP", "stricmp", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRDUP", "strdup", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRCASECMP", "strcasecmp", {includes={"strings.h"}})
configvar_check_cfuncs("HAVE_SETMODE", "setmode", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_SETLOCALE", "setlocale", {includes={"locale.h"}})
configvar_check_cfuncs("HAVE_GETTIMEOFDAY", "gettimeofday", {includes={"sys/time.h"}})
configvar_check_cfuncs("HAVE_FTRUNCATE", "ftruncate", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_ARC4RANDOM", "arc4random", {includes={"stdlib.h"}})
configvar_check_cfuncs("HAVE_FNMATCH", "fnmatch", {includes={"fnmatch.h"}})
configvar_check_cfuncs("HAVE_BASENAME", "basename", {includes={"libgen.h"}})
configvar_check_cfuncs("HAVE_SCHED_YIELD", "sched_yield", {includes={"sched.h"}})
configvar_check_cfuncs("HAVE_SOCKETPAIR", "socketpair", {includes={"sys/socket.h"}})
configvar_check_cfuncs("HAVE_MEMRCHR", "memrchr", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRCMPI", "strcmpi", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRTOK_R", "strtok_r", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_STRERROR_R", "strerror_r", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_FCNTL", "fcntl", {includes={"fcntl.h"}})
configvar_check_cfuncs("HAVE_GETPPID", "getppid", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_SIGSETJMP", "sigsetjmp", {includes={"setjmp.h"}})
configvar_check_cfuncs("HAVE_SETRLIMIT", "setrlimit", {includes={"sys/time.h", "sys/resource.h"}})
configvar_check_cfuncs("HAVE_MACH_ABSOLUTE_TIME", "mach_absolute_time", {includes={"mach/mach_time.h"}})
configvar_check_cfuncs("HAVE_FSETXATTR", "fsetxattr", {includes={"sys/xattr.h"}})
configvar_check_cfuncs("HAVE_PIPE", "pipe", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_BASENAME", "basename", {includes={"string.h"}})
configvar_check_cfuncs("HAVE_FSEEKO", "fseeko", {includes={"stdio.h"}})
configvar_check_cfuncs("HAVE__FSEEKI64", "_fseeki64", {includes={"stdio.h"}})
configvar_check_cfuncs("HAVE_GETEUID", "geteuid", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_GETPPID", "getppid", {includes={"unistd.h"}})
configvar_check_cfuncs("HAVE_GETIFADDRS", "getifaddrs", {includes={"ifaddrs.h"}})
configvar_check_cfuncs("HAVE_GETPWUID", "getpwuid", {includes={"pwd.h"}})
configvar_check_cfuncs("HAVE_GETPWUID_R", "getpwuid_r", {includes={"pwd.h"}})
configvar_check_cfuncs("HAVE_GETRLIMIT", "getrlimit", {includes={"sys/resource.h"}})
configvar_check_cfuncs("HAVE_GMTIME_R", "gmtime_r", {includes={"time.h"}})
configvar_check_cfuncs("HAVE_LDAP_URL_PARSE", "ldap_url_parse", {includes={"ldap.h"}})
configvar_check_cfuncs("HAVE_LDAP_INIT_FD", "ldap_init_fd", {includes={"ldap.h"}})
configvar_check_csymbol_exists("HAVE_CLOCK_GETTIME_MONOTONIC", "CLOCK_MONOTONIC", {includes={"time.h"}})
configvar_check_csymbol_exists("HAVE_CLOCK_GETTIME_MONOTONIC_RAW", "CLOCK_MONOTONIC_RAW", {includes={"time.h"}})

configvar_check_csnippets("HAVE_BUILTIN_AVAILABLE", [[
#include <stdlib.h>
int main() {
  if(__builtin_available(macOS 10.12, *)) {}
  return 0;
}]])

configvar_check_csnippets("HAVE_FSETXATTR_6", [[
#include <sys/types.h>
#include <sys/xattr.h>

int main() {
    if(0 != fsetxattr(0, 0, 0, 0, 0, 0))
    return 1;
}]])

configvar_check_csnippets("HAVE_FSETXATTR_5", [[
#include <sys/types.h>
#include <sys/xattr.h>

int main() {
    if(0 != fsetxattr(0, 0, 0, 0, 0))
    return 1;
}]])

configvar_check_csnippets("HAVE_MSG_NOSIGNAL", [[
#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <winsock2.h>
#else
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#endif

int main(void) {
    int flag=MSG_NOSIGNAL;
    return 0;
}]])

if os.exists("/dev/urandom") then
    set_configvar("RANDOM_FILE", "/dev/urandom")
end

configvar_check_csymbol_exists("HAVE_FCNTL_O_NONBLOCK", "O_NONBLOCK", {includes={"fcntl.h"}})
if is_plat("windows", "mingw") then
    set_configvar("USE_WIN32_LARGE_FILES", 1)
    set_configvar("USE_UNIX_SOCKETS", 1)
    configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")
    configvar_check_cincludes("HAVE_WINLDAP_H", {"windows.h", "winldap.h"})
    configvar_check_cincludes("HAVE_WINSOCK2_H", "winsock2.h")
    configvar_check_cincludes("HAVE_WS2TCPIP_H", "ws2tcpip.h")
    configvar_check_csymbol_exists("HAVE_SETSOCKOPT_SO_NONBLOCK", "SO_NONBLOCK", {includes={"winsock2.h"}})
    configvar_check_cfuncs("HAVE_IOCTLSOCKET", "ioctlsocket", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_GETADDRINFO", "getaddrinfo", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_GETPEERNAME", "getpeername", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_GETSOCKNAME", "getsockname", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_GETHOSTNAME", "gethostname", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_CLOSESOCKET", "closesocket", {includes={"winsock2.h", "ws2tcpip.h"}})
    configvar_check_csnippets("HAVE_IOCTLSOCKET_FIONBIO", [[
#include <winsock2.h>
#include <ws2tcpip.h>
int main() {
    ioctlsocket(0, FIONBIO, 0);
    return 0;
}]])
--     configvar_check_csnippets("HAVE_IOCTL_FIONBIO", [[
-- #include <winsock2.h>
-- #include <ws2tcpip.h>
-- int main() {
--     ioctl(0, FIONBIO, 0);
--     return 0;
-- }]])
--     configvar_check_csnippets("HAVE_IOCTL_SIOCGIFADDR", [[
-- #include <winsock2.h>
-- #include <ws2tcpip.h>
-- int main() {
--     ioctl(0, SIOCGIFADDR, 0);
--     return 0;
-- }]])
    configvar_check_csymbol_exists("HAVE_MSG_NOSIGNAL", "MSG_NOSIGNAL", {includes={"winsock2.h"}})
    configvar_check_ctypes("HAVE_STRUCT_TIMEVAL", "struct timeval", {includes={"windows.h"}})
    configvar_check_cfuncs("HAVE_FREEADDRINFO", "freeaddrinfo", {includes={"ws2tcpip.h"}})
    configvar_check_cfuncs("HAVE_IF_NAMETOINDEX", "if_nametoindex", {includes = {"netioapi.h"}})
else
    configvar_check_ctypes("HAVE_STRUCT_TIMEVAL", "struct timeval", {includes={"time.h"}})
    configvar_check_ctypes("USE_UNIX_SOCKETS", "struct sockaddr_un", {includes={"sys/un.h"}})
    configvar_check_csymbol_exists("HAVE_SETSOCKOPT_SO_NONBLOCK", "SO_NONBLOCK", {includes={"sys/socket.h"}})
    configvar_check_csnippets("HAVE_IOCTL_FIONBIO", [[
#include <sys/socket.h>
#include <sys/ioctl.h>
int main() {
    ioctl(0, FIONBIO, 0);
    return 0;
}]])
    configvar_check_csnippets("HAVE_IOCTL_SIOCGIFADDR", [[
#include <sys/socket.h>
#include <net/if.h>
#include <sys/ioctl.h>
int main() {
    ioctl(0, SIOCGIFADDR, 0);
    return 0;
}]])
    configvar_check_csymbol_exists("HAVE_MSG_NOSIGNAL", "MSG_NOSIGNAL", {includes={"sys/socket.h"}})
    configvar_check_cfuncs("HAVE_GETSOCKNAME", "getsockname", {includes={"sys/socket.h"}})
    configvar_check_cfuncs("HAVE_GETPEERNAME", "getpeername", {includes={"sys/socket.h"}})
    configvar_check_cfuncs("HAVE_GETHOSTNAME", "gethostname", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_FREEADDRINFO", "freeaddrinfo", {includes={"netdb.h"}})
    configvar_check_cfuncs("HAVE_GETADDRINFO", "getaddrinfo", {includes={"netdb.h"}})
    set_configvar("CURL_EXTERN_SYMBOL", "__attribute__ ((__visibility__ (\"default\")))", {quote = false})
    set_configvar("CURL_CA_BUNDLE", "/etc/ssl/cert.pem")
    set_configvar("CURL_CA_PATH", "/etc/ssl/certs")
    configvar_check_cfuncs("HAVE_IF_NAMETOINDEX", "if_nametoindex", {includes = {"net/if.h"}})

end
configvar_check_cfuncs("HAVE_SENDMSG", "sendmsg", {includes={"sys/socket.h"}})
configvar_check_ctypes("HAVE_SSIZE_T", "ssize_t", {includes={"sys/types.h"}})
configvar_check_ctypes("HAVE_LONGLONG", "long long")
configvar_check_ctypes("HAVE_BOOL_T", "bool", {includes={"stdbool.h"}})
configvar_check_ctypes("HAVE_STRUCT_SOCKADDR_STORAGE", "struct sockaddr_storage", {includes={"sys/socket.h"}})
configvar_check_ctypes("HAVE_SA_FAMILY_T", "sa_family_t", {includes={"sys/socket.h"}})

configvar_check_sizeof("SIZEOF_INT", "int")
configvar_check_sizeof("SIZEOF_LONG", "long")
configvar_check_sizeof("SIZEOF_LONG_LONG", "long long")
configvar_check_sizeof("SIZEOF_SIZE_T", "size_t", {includes={"stddef.h"}})
configvar_check_sizeof("SIZEOF_TIME_T", "time_t", {includes={"time.h"}})
configvar_check_sizeof("SIZEOF_CURL_OFF_T", 'curl_off_t', {
    includes={"include/curl/system.h"},
    cxflags=cxflags
})
configvar_check_sizeof("SIZEOF_OFF_T", 'off_t', {
    includes={"sys/types.h"},
})
configvar_check_sizeof("SIZEOF_CURL_SOCKET_T", 'curl_socket_t', {
    includes={"include/curl/curl.h"},
    cxflags=cxflags
})

set_configvar("STDC_HEADERS", 1)
configvar_check_ctypes("HAVE_SUSECONDS_T", "suseconds_t", {includes = {"sys/time.h"}})
set_configvar("HAVE_INET_NTOP", 1)
set_configvar("HAVE_INET_PTON", 1)
set_configvar("_FILE_OFFSET_BITS", 64)
set_configvar("HAVE_GETADDRINFO_THREADSAFE", 1)

if is_plat("windows", "mingw") then
    set_configvar("USE_WINDOWS_SSPI", 1)
    set_configvar("USE_THREADS_WIN32", 1)
    if get_config("winrt") then
        set_configvar("CURL_DISABLE_LDAP", 1)
    else
        set_configvar("USE_WIN32_LDAP", 1)
        set_configvar("HAVE_LDAP_SSL", 1)
        add_syslinks("wldap32")
    end
    configvar_check_cfuncs("HAVE_SOCKET", "socket", {includes={"winsock2.h"}})
    configvar_check_cfuncs("HAVE_SELECT", "select", {includes={"winsock2.h"}})
    configvar_check_cfuncs("HAVE_RECV", "recv", {includes={"winsock2.h"}})
    configvar_check_cfuncs("HAVE_SEND", "send", {includes={"winsock2.h"}})
    set_configvar("USE_WIN32_CRYPTO", 1)
    add_defines("UNICODE", "_UNICODE")
else
    set_configvar("HAVE_LDAP_SSL", 1)
    set_configvar("USE_THREADS_POSIX", 1)
    set_configvar("USE_UNIX_SOCKETS", 1)
    configvar_check_cfuncs("HAVE_SOCKET", "socket", {includes={"sys/socket.h"}})
    configvar_check_cfuncs("HAVE_SELECT", "select", {includes={"sys/select.h"}})
    configvar_check_cfuncs("HAVE_RECV", "recv", {includes={"sys/socket.h"}})
    configvar_check_cfuncs("HAVE_SEND", "send", {includes={"sys/socket.h"}})
    set_configvar("HAVE_POSIX_STRERROR_R", 1)
end

if not get_config("nghttp3") and not get_config("nghttp2") then
    set_configvar("CURL_WITH_MULTI_SSL", 1)
end


set_configvar("HAVE_ATOMIC", 1)
set_configvar("USE_WEBSOCKETS", 1)
set_configvar("HAVE_WRITABLE_ARGV", 1)
set_configvar("HAVE_DECL_FSEEKO", 1)
set_configvar("USE_IPV6", 1)
set_configvar("USE_TLS_SRP", 1)

configvar_check_csnippets("ENABLE_IPV6", [[
#include <sys/types.h>
#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#include <sys/socket.h>
#include <netinet/in.h>
#if defined (__TANDEM)
# include <netinet/in6.h>
#endif
#endif
int main(void) {
    struct sockaddr_in6 s;
    (void)s;
    return socket(AF_INET6, SOCK_STREAM, 0) < 0;
}]])
local sockaddr_in6_include = {}
if is_plat("windows", "mingw") then
    table.join2(sockaddr_in6_include, {
        "winsock2.h",
        "ws2tcpip.h",
    })
else
    table.join2(sockaddr_in6_include, {
        "sys/socket.h",
        "netinet/in.h",
    })
end
-- configvar_check_has_member("HAVE_SOCKADDR_IN6_SIN6_ADDR", "struct sockaddr_in6", "sin6_addr", {includes = sockaddr_in6_include})
configvar_check_has_member("HAVE_SOCKADDR_IN6_SIN6_SCOPE_ID", "struct sockaddr_in6", "sin6_scope_id", {includes = sockaddr_in6_include})


-- TODO
-- cares
-- gss by https://github.com/heimdal/heimdal

-- if os.exists("/usr/bin/ntlm_auth") then
--     set_configvar("NTLM_WB_ENABLED", 1)
--     set_configvar("NTLM_WB_FILE", "/usr/bin/ntlm_auth")
-- end
target("curl")
    set_kind("$(kind)")
    add_includedirs("lib", "include")
    add_headerfiles("$(buildir)/config/curl_config.h", {prefixdir = "curl"})
    add_headerfiles("include/curl/*.h", {prefixdir = "curl"})
    if is_kind("shared") then
        add_defines("BUILDING_LIBCURL")
    else
        add_defines("BUILDING_LIBCURL", "CURL_STATICLIB")
    end
    add_defines("HAVE_CONFIG_H=1")

    set_configvar("HAVE_ZLIB_H", 1)
    set_configvar("HAVE_LIBZ", 1)
    
    on_config(function (target)
        target:add("defines", "CURL_OS="..vformat('"xmake:$(os)-$(arch)"'))
    end)

    if is_plat("windows", "mingw") then
        set_configvar("USE_WIN32_IDN", 1)
        set_configvar("USE_SCHANNEL", 1)
        add_syslinks("crypt32", "bcrypt", "advapi32", "ws2_32", "normaliz")
        add_files("lib/libcurl.rc")
    elseif is_plat("macosx") then
        -- http3 不支持多 tls 后端
        if not get_config("nghttp3") then
            set_configvar("USE_SECTRANSP", 1)
        end
        add_frameworks("CoreFoundation", "SystemConfiguration", "Security")
        add_syslinks("ldap", "icucore", "iconv")
        set_configvar("USE_APPLE_IDN", 1)
    elseif is_plat("linux") then
        set_configvar("CURL_DISABLE_LDAP", 1)
    end
    add_packages("zlib")
    if get_config("libressl") then
        add_packages("libressl")
        set_configvar("USE_OPENSSL", 1)
        set_configvar("OPENSSL_EXTRA", 1)
        set_configvar("HAVE_LIBRESSL", 1)
    elseif get_config("wolfssl") then
        add_packages("wolfssl")
        set_configvar("USE_OPENSSL", 1)
        set_configvar("OPENSSL_EXTRA", 1)
    end
    if get_config("brotli") then
        add_packages("brotli")
        set_configvar("HAVE_BROTLI_DECODE_H", 1)
        set_configvar("HAVE_BROTLI", 1)
    end
    if get_config("zstd") then
        add_packages("zstd")
        set_configvar("HAVE_ZSTD_H", 1)
        set_configvar("HAVE_ZSTD", 1)
    end
    if get_config("ssh2") then
        add_packages("ssh2", {public = true})
        set_configvar("HAVE_LIBSSH2", 1)
        set_configvar("USE_LIBSSH2", 1)
    end
    if get_config("ngtcp2") then
        add_packages("ngtcp2", {public = true})
        set_configvar("USE_NGTCP2", 1)
    end
    if get_config("nghttp2") then
        add_packages("nghttp2", {public = true})
        set_configvar("USE_NGHTTP2", 1)
    end
    if get_config("nghttp3") then
        add_packages("nghttp3")
        set_configvar("USE_NGHTTP3", 1)
        if get_config("ngtcp2") then
            set_configvar("USE_NGTCP2_H3", 1)
        end
        set_configvar("USE_OPENSSL_H3", 1)
    end
    if get_config("httponly") then
        add_defines("HTTP_ONLY=1")
    end
    add_files(
        "lib/*.c",
        "lib/vtls/*.c",
        "lib/vauth/*.c",
        "lib/vquic/*.c",
        "lib/vssh/*.c"
    )

target("curl_cli")
    set_default(get_config("cli") or false)
    set_kind("binary")
    set_basename("curl")
    add_defines(
        "HAVE_CONFIG_H=1",
        "CURL_STATICLIB",
        "BUILDING_LIBCURL",
        "BUILDING_CURL_CLI",
        "curlx_now=Curl_now",
        "curlx_timediff=Curl_timediff",
        "curlx_timediff_ceil=Curl_timediff_ceil",
        "curlx_timediff_us=Curl_timediff_us"
    )
    on_config(function (target)
        target:add("defines", "CURL_OS="..vformat('"$(arch)-pc-$(os)"'))
    end)
    add_deps("curl")
    add_includedirs("lib", "include", "$(buildir)/config")
    add_files("src/*.c")
    if is_plat("windows", "mingw") then
        add_files("src/curl.rc")
    end
