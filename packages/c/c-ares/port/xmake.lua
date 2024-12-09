includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

local function configvar_check_csymbol_exists(define_name, var_name, opt)
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

local function configvar_check_chas_member(define_name, type_name, member, opt)
    configvar_check_csnippets(define_name, format([[
void has_member() {
    %s a;
    a.%s;
}]], type_name, member), opt)
end

local function configvar_check_clibrary_exists(define_name, fun_name, library_name, opt)
    opt = opt or {}
    if library_name then
        opt.links = {library_name}
    end
    configvar_check_csnippets(define_name, format([[
#define CHECK_FUNCTION_EXISTS %s
#ifdef CHECK_FUNCTION_EXISTS
#  ifdef __cplusplus
extern "C"
#  endif
  char
  CHECK_FUNCTION_EXISTS(void);
#  ifdef __CLASSIC_C__
int main()
{
  int ac;
  char* av[];
#  else
int main(int ac, char* av[])
{
#  endif
  CHECK_FUNCTION_EXISTS();
  if (ac > 1000) {
    return *av[0];
  }
  return 0;
}
#else /* CHECK_FUNCTION_EXISTS */
#  error "CHECK_FUNCTION_EXISTS has to specify the function"
#endif /* CHECK_FUNCTION_EXISTS */
]], fun_name), opt)
end

function CARES_FUNCTION_IN_LIBRARY(define_name, fun_name, lib_name, opt)
    configvar_check_clibrary_exists("NOT_"..define_name, fun_name)
    configvar_check_clibrary_exists(define_name, fun_name, lib_name, opt)
end

CARES_FUNCTION_IN_LIBRARY("HAVE_RES_SERVICENAME_IN_LIBRESOLV", "res_servicename", "resolv")

if is_plat("macosx", "iphoneos") then
    configvar_check_csnippets('IOS', [[
#include <stdio.h>
#include <TargetConditionals.h>

int main() {
    #if TARGET_OS_IPHONE == 0
    #error Not an iPhone target
    #endif
    return 0;
}
]])
    configvar_check_csnippets('IOS_V10', [[
#include <stdio.h>
#include <TargetConditionals.h>

int main() {
    #if TARGET_OS_IPHONE == 0 || __IPHONE_OS_VERSION_MIN_REQUIRED < 100000
    #  error Not iOS v10
    #endif
    return 0;
}
]])
    configvar_check_csnippets('MACOS_V1012', [[
#include <stdio.h>
#include <AvailabilityMacros.h>
#ifndef MAC_OS_X_VERSION_10_12
#  define MAC_OS_X_VERSION_10_12 101200
#endif

int main() {
    #if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_12
    #  error Not MacOSX 10.12 or higher
    #endif
    return 0;
}
]])
end

CARES_FUNCTION_IN_LIBRARY("HAVE_LIBNSL", "gethostbyname", "nsl")
CARES_FUNCTION_IN_LIBRARY("HAVE_GHBN_LIBSOCKET", "gethostbyname", "socket")
CARES_FUNCTION_IN_LIBRARY("HAVE_LIBNETWORK", "gethostbyname", "network")
CARES_FUNCTION_IN_LIBRARY("HAVE_SOCKET_LIBSOCKET", "socket", "socket")
CARES_FUNCTION_IN_LIBRARY("HAVE_LIBNETWORK", "socket", "network")
CARES_FUNCTION_IN_LIBRARY("HAVE_LIBRT", "clock_gettime", "rt")

configvar_check_cincludes("HAVE_AVAILABILITYMACROS_H", "AvailabilityMacros.h")
configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
configvar_check_cincludes("HAVE_SYS_RANDOM_H", "sys/random.h")
configvar_check_cincludes("HAVE_SYS_SOCKET_H", "sys/socket.h")
configvar_check_cincludes("HAVE_SYS_SOCKIO_H", "sys/sockio.h")
configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
configvar_check_cincludes("HAVE_ARPA_NAMESER_COMPAT_H", "arpa/nameser_compat.h")
configvar_check_cincludes("HAVE_ARPA_NAMESER_H", "arpa/nameser.h")
configvar_check_cincludes("HAVE_ASSERT_H", "assert.h")
configvar_check_cincludes("HAVE_ERRNO_H", "errno.h")
configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_LIMITS_H", "limits.h")
configvar_check_cincludes("HAVE_MALLOC_H", "malloc.h")
configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
configvar_check_cincludes("HAVE_NETDB_H", "netdb.h")
configvar_check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")
configvar_check_cincludes("HAVE_NETINET6_IN6_H", "netinet6/in6.h")
configvar_check_cincludes("HAVE_NET_IF_H", "net/if.h")
configvar_check_cincludes("HAVE_SIGNAL_H", "signal.h")
configvar_check_cincludes("HAVE_SOCKET_H", "socket.h")
configvar_check_cincludes("HAVE_STDBOOL_H", "stdbool.h")
configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
configvar_check_cincludes("HAVE_STRING_H", "string.h")
configvar_check_cincludes("HAVE_STROPTS_H", "stropts.h")
configvar_check_cincludes("HAVE_SYS_IOCTL_H", "sys/ioctl.h")
configvar_check_cincludes("HAVE_SYS_PARAM_H", "sys/param.h")
configvar_check_cincludes("HAVE_SYS_SELECT_H", "sys/select.h")
configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
configvar_check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
configvar_check_cincludes("HAVE_SYS_UIO_H", "sys/uio.h")
configvar_check_cincludes("HAVE_SYS_EVENT_H", "sys/event.h")
configvar_check_cincludes("HAVE_SYS_EPOLL_H", "sys/epoll.h")
configvar_check_cincludes("HAVE_IFADDRS_H", "ifaddrs.h")
configvar_check_cincludes("HAVE_TIME_H", "time.h")
configvar_check_cincludes("HAVE_POLL_H", "poll.h")
configvar_check_cincludes("HAVE_DLFCN_H", "dlfcn.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cincludes("HAVE_NETINET_TCP_H", "netinet/tcp.h")
configvar_check_cincludes("HAVE_PTHREAD_H", "pthread.h")
configvar_check_cincludes("HAVE_PTHREAD_NP_H", "pthread_np.h")
configvar_check_sizeof("SIZEOF_SIZEOF_VOID_P", "void*")

if is_plat("windows", "mingw") then
    configvar_check_cincludes("HAVE_WINSOCK2_H", {"winsock2.h"})
    configvar_check_cincludes("HAVE_WS2TCPIP_H", {"ws2tcpip.h"})
    configvar_check_cincludes("HAVE_IPHLPAPI_H", {"winsock2.h", "windows.h", "ws2tcpip.h", "iphlpapi.h"})
    configvar_check_cincludes("HAVE_NETIOAPI_H", {"winsock2.h", "windows.h", "ws2tcpip.h", "iphlpapi.h", "netioapi.h"})
    configvar_check_cincludes("HAVE_MSWSOCK_H", {"mswsock.h"})
    configvar_check_cincludes("HAVE_WINSOCK_H", {"winsock.h"})
    configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")
    configvar_check_cincludes("HAVE_WINTERNL_H", {"winternl.h"})
    configvar_check_cincludes("HAVE_NTDEF_H", {"ntdef.h"})
    configvar_check_cincludes("HAVE_NTSTATUS_H", {"ntstatus.h"})
end

local network_include = {}
if is_plat("windows", "mingw") then
    network_include = {"winsock2.h", "ws2tcpip.h", "windows.h"}
else
    network_include = {"sys/types.h", "sys/socket.h", "sys/ioctl.h", "netdb.h", "fcntl.h"}
end

configvar_check_ctypes("HAVE_SOCKLEN_T", "socklen_t", {includes = network_include})
configvar_check_ctypes("HAVE_TYPE_SOCKET", "SOCKET", {includes = network_include})
configvar_check_ctypes("HAVE_SSIZE_T", "ssize_t", {includes = network_include})
configvar_check_ctypes("HAVE_LONGLONG", "long long", {includes = network_include})
configvar_check_ctypes("HAVE_STRUCT_ADDRINFO", "struct addrinfo", {includes = network_include})
configvar_check_ctypes("HAVE_STRUCT_IN6_ADDR", "struct in6_addr", {includes = network_include})
configvar_check_ctypes("HAVE_STRUCT_SOCKADDR_IN6", "struct sockaddr_in6", {includes = network_include})
configvar_check_ctypes("HAVE_STRUCT_SOCKADDR_STORAGE", "struct sockaddr_storage", {includes = network_include})
if is_plat("windows", "mingw") then
    configvar_check_ctypes("HAVE_STRUCT_TIMEVAL", "struct timeval", {includes = "winsock2.h"})
else
    configvar_check_ctypes("HAVE_STRUCT_TIMEVAL", "struct timeval", {includes = "sys/time.h"})
end

configvar_check_csymbol_exists("HAVE_AF_INET6", "AF_INET6", {includes = network_include})
configvar_check_csymbol_exists("HAVE_O_NONBLOCK", "O_NONBLOCK", {includes = network_include})
configvar_check_csymbol_exists("HAVE_FIONBIO", "FIONBIO", {includes = network_include})
configvar_check_csymbol_exists("HAVE_IOCTL_SIOCGIFADDR", "SIOCGIFADDR", {includes = network_include})
configvar_check_csymbol_exists("HAVE_MSG_NOSIGNAL", "MSG_NOSIGNAL", {includes = network_include})
configvar_check_csymbol_exists("HAVE_PF_INET6", "PF_INET6", {includes = network_include})
configvar_check_csymbol_exists("HAVE_SO_NONBLOCK", "SO_NONBLOCK", {includes = network_include})
configvar_check_csymbol_exists("HAVE_PTHREAD_INIT", "pthread_init", {includes = "pthread.h"})

configvar_check_chas_member("HAVE_STRUCT_SOCKADDR_IN6_SIN6_SCOPE_ID", "struct sockaddr_in6", "sin6_scope_id", {includes = {"sys/socket.h", "netinet/in.h"}})

local iphlpapi_includes = {"winsock2.h", "windows.h", "ws2tcpip.h", "iphlpapi.h"}

configvar_check_csymbol_exists("HAVE_MEMMEM", "memmem", {includes = "string.h"})
configvar_check_csymbol_exists("HAVE_CLOSESOCKET", "closesocket", {includes = network_include})
configvar_check_csymbol_exists("HAVE_CLOSESOCKET_CAMEL", "CloseSocket", {includes = network_include})
configvar_check_csymbol_exists("HAVE_CONNECT", "connect", {includes = network_include})
configvar_check_csymbol_exists("HAVE_CONNECTX", "connectx", {includes = network_include})
configvar_check_csymbol_exists("HAVE_FCNTL", "fcntl", {includes = "fcntl.h"})
configvar_check_csymbol_exists("HAVE_FREEADDRINFO", "freeaddrinfo", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETADDRINFO", "getaddrinfo", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETENV", "getenv", {includes = "stdlib.h"})
configvar_check_csymbol_exists("HAVE_GETHOSTNAME", "gethostname", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETNAMEINFO", "getnameinfo", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETRANDOM", "getrandom", {includes = "sys/random.h"})
configvar_check_csymbol_exists("HAVE_GETSERVBYPORT_R", "getservbyport_r", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETSERVBYNAME_R", "getservbyname_r", {includes = network_include})
configvar_check_csymbol_exists("HAVE_GETTIMEOFDAY", "gettimeofday", {includes = "sys/time.h"})
configvar_check_csymbol_exists("HAVE_IF_INDEXTONAME", "if_indextoname", {includes = "net/if.h"})
configvar_check_csymbol_exists("HAVE_IF_NAMETOINDEX", "if_nametoindex", {includes = "net/if.h"})
configvar_check_csymbol_exists("HAVE_CONVERTINTERFACEINDEXTOLUID", "ConvertInterfaceIndexToLuid", {includes = iphlpapi_includes})
configvar_check_csymbol_exists("HAVE_CONVERTINTERFACELUIDTONAMEA", "ConvertInterfaceLuidToNameA", {includes = iphlpapi_includes})
configvar_check_csymbol_exists("HAVE_NOTIFYIPINTERFACECHANGE", "NotifyIpInterfaceChange", {includes = iphlpapi_includes})
configvar_check_csymbol_exists("HAVE_REGISTERWAITFORSINGLEOBJECT", "RegisterWaitForSingleObject", {includes = "windows.h"})
configvar_check_csymbol_exists("HAVE_INET_NET_PTON", "inet_net_pton", {includes = "arpa/inet.h"})

if not is_plat("windows", "mingw") then
    configvar_check_csymbol_exists("HAVE_INET_NTOP", "inet_ntop", {includes = "arpa/inet.h"})
    configvar_check_csymbol_exists("HAVE_INET_PTON", "inet_pton", {includes = "arpa/inet.h"})
end

configvar_check_csymbol_exists("HAVE_IOCTL", "ioctl", {includes = "stropts.h"})
configvar_check_csymbol_exists("HAVE_IOCTLSOCKET", "ioctlsocket", {includes = network_include})
configvar_check_csymbol_exists("HAVE_IOCTLSOCKET_CAMEL", "IoctlSocket", {includes = network_include})
configvar_check_csymbol_exists("HAVE_RECV", "recv", {includes = network_include})
configvar_check_csymbol_exists("HAVE_RECVFROM", "recvfrom", {includes = network_include})
configvar_check_csymbol_exists("HAVE_SEND", "send", {includes = network_include})
configvar_check_csymbol_exists("HAVE_SENDTO", "sendto", {includes = network_include})
configvar_check_csymbol_exists("HAVE_SETSOCKOPT", "setsockopt", {includes = network_include})
configvar_check_csymbol_exists("HAVE_SOCKET", "socket", {includes = network_include})
configvar_check_csymbol_exists("HAVE_STRCASECMP", "strcasecmp", {includes = "strings.h"})
configvar_check_csymbol_exists("HAVE_STRCMPI", "strcmpi", {includes = "string.h"})
configvar_check_csymbol_exists("HAVE_STRDUP", "strdup", {includes = "string.h"})
configvar_check_csymbol_exists("HAVE_STRICMP", "stricmp", {includes = "string.h"})
configvar_check_csymbol_exists("HAVE_STRNCASECMP", "strncasecmp", {includes = "strings.h"})
configvar_check_csymbol_exists("HAVE_STRNCMPI", "strncmpi", {includes = "strings.h"})
configvar_check_csymbol_exists("HAVE_STRNICMP", "strnicmp", {includes = "string.h"})
configvar_check_csymbol_exists("HAVE_WRITEV", "writev", {includes = "sys/uio.h"})
configvar_check_csymbol_exists("HAVE_ARC4RANDOM_BUF", "arc4random_buf", {includes = "stdlib.h"})
configvar_check_csymbol_exists("HAVE_STAT", "stat", {includes = {"sys/types.h", "sys/stat.h"}})
configvar_check_csymbol_exists("HAVE_GETIFADDRS", "getifaddrs", {includes = {"sys/types.h", "ifaddrs.h"}})
configvar_check_csymbol_exists("HAVE_POLL", "poll", {includes = "poll.h"})
configvar_check_csymbol_exists("HAVE_PIPE", "pipe", {includes = "unistd.h"})
configvar_check_csymbol_exists("HAVE_PIPE2", "pipe2", {includes = "unistd.h"})
configvar_check_csymbol_exists("HAVE_KQUEUE", "kqueue", {includes = "sys/event.h"})
configvar_check_csymbol_exists("HAVE_EPOLL", "epoll_create1", {includes = "sys/epoll.h"})

configvar_check_cfuncs("HAVE___SYSTEM_PROPERTY_GET", "__system_property_get", {includes = "sys/system_properties.h"})

if is_plat("macosx", "iphoneos") then
    add_defines("_DARWIN_C_SOURCE")
    configvar_check_csymbol_exists("HAVE_CLOCK_GETTIME_MONOTONIC", "CLOCK_MONOTONIC", {includes = "time.h"})
    add_syslinks("pthread")
elseif is_plat("linux", "android") then
    add_defines("_GNU_SOURCE", "_POSIX_C_SOURCE=200809L", "_XOPEN_SOURCE=700")
    add_syslinks("pthread")
elseif is_plat("windows", "mingw") then
    add_defines(
        "WIN32_LEAN_AND_MEAN",
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_NONSTDC_NO_DEPRECATE",
        "_WIN32_WINNT=0x0602"
    )
    add_syslinks("ws2_32", "advapi32", "iphlpapi")
end

target("cares")
    set_kind("$(kind)")
    on_config(function (target)
        local c = import("check")(target)
        local set_configvar = function(k, v) c:set_configvar(k, v) end
        local get_configvar = function(k) return c:get_configvar(k) end
        local is_win32 = target:is_plat("windows", "mingw")
        if get_configvar('HAVE_SSIZE_T') and get_configvar('HAVE_SOCKLEN_T') and not is_win32 then
            set_configvar('RECVFROM_TYPE_RETV', 'ssize_t')
            set_configvar('RECVFROM_TYPE_ARG3', 'size_t')
            set_configvar('CARES_TYPEOF_ARES_SSIZE_T', 'ssize_t')
        else
            set_configvar('RECVFROM_TYPE_RETV', 'int')
            set_configvar('RECVFROM_TYPE_ARG3', 'int')
            if is_win32 then
                if tostring(get_configvar('SIZEOF_SIZEOF_VOID_P')) == '8' then
                    set_configvar('CARES_TYPEOF_ARES_SSIZE_T', '__int64')
                else
                    set_configvar('CARES_TYPEOF_ARES_SSIZE_T', 'int')
                end
            else
                set_configvar('CARES_TYPEOF_ARES_SSIZE_T', 'long')
            end
            set_configvar('CARES_TYPEOF_ARES_SSIZE_T', 'int')
        end
        if get_configvar('HAVE_TYPE_SOCKET') then
            set_configvar('RECVFROM_TYPE_ARG1', 'SOCKET')
        else
            set_configvar('RECVFROM_TYPE_ARG1', 'int')
        end
        if get_configvar('HAVE_SOCKLEN_T') then
            set_configvar('RECVFROM_TYPE_ARG6', 'socklen_t *')
            set_configvar('GETNAMEINFO_TYPE_ARG2', 'socklen_t')
            set_configvar('GETNAMEINFO_TYPE_ARG46', 'socklen_t')
            set_configvar('CARES_TYPEOF_ARES_SOCKLEN_T', 'socklen_t')
        else
            set_configvar('RECVFROM_TYPE_ARG6', 'int *')
            set_configvar('GETNAMEINFO_TYPE_ARG2', 'int')
            set_configvar('GETNAMEINFO_TYPE_ARG46', 'int')
            set_configvar('CARES_TYPEOF_ARES_SOCKLEN_T', 'int')
        end
        if is_win32 then
            set_configvar('RECV_TYPE_ARG2', 'char *')
        else
            set_configvar('RECV_TYPE_ARG2', 'void *')
        end

        set_configvar('RECV_TYPE_RETV', get_configvar('RECVFROM_TYPE_RETV'))
        set_configvar('SEND_TYPE_RETV', get_configvar('RECVFROM_TYPE_RETV'))
        set_configvar('RECV_TYPE_ARG1', get_configvar('RECVFROM_TYPE_ARG1'))
        set_configvar('RECVFROM_TYPE_ARG2', get_configvar('RECV_TYPE_ARG2'))
        set_configvar('SEND_TYPE_ARG1', get_configvar('RECVFROM_TYPE_ARG1'))
        set_configvar('RECV_TYPE_ARG3', get_configvar('RECVFROM_TYPE_ARG3'))
        set_configvar('SEND_TYPE_ARG3', get_configvar('RECVFROM_TYPE_ARG3'))
        set_configvar('GETHOSTNAME_TYPE_ARG2', get_configvar('RECVFROM_TYPE_ARG3'))

        set_configvar('RECVFROM_QUAL_ARG5', '')
        set_configvar('RECVFROM_TYPE_ARG4', 'int')
        set_configvar('RECVFROM_TYPE_ARG5', 'struct sockaddr *')
        set_configvar('RECV_TYPE_ARG4', 'int')
        set_configvar('GETNAMEINFO_TYPE_ARG1', 'struct sockaddr *')
        set_configvar('GETNAMEINFO_TYPE_ARG7', 'int')
        set_configvar('SEND_TYPE_ARG2', 'const void *')
        set_configvar('SEND_TYPE_ARG4', 'int')
        set_configvar('GETNAMEINFO_QUAL_ARG1', 0)

        if get_configvar('HAVE_FCNTL') and get_configvar('HAVE_O_NONBLOCK') then
            set_configvar('HAVE_FCNTL_O_NONBLOCK', 1)
        end

        if get_configvar('HAVE_IOCTL') and get_configvar('HAVE_FIONBIO') then
            set_configvar('HAVE_IOCTL_FIONBIO', 1)
        end

        if get_configvar('HAVE_IOCTLSOCKET') and get_configvar('HAVE_FIONBIO') then
            set_configvar('HAVE_IOCTLSOCKET_FIONBIO', 1)
        end

        if get_configvar('HAVE_IOCTLSOCKET_CAMEL') and get_configvar('HAVE_FIONBIO') then
            set_configvar('HAVE_IOCTLSOCKET_CAMEL_FIONBIO', 1)
        end

        if get_configvar('HAVE_GETADDRINFO') and (is_win32 or target:is_plat("macosx", "iphoneos")) then
            set_configvar('HAVE_GETADDRINFO_THREADSAFE', 1)
        end

        if get_configvar('HAVE_TIME_H', 'HAVE_SYS_TIME_H') then
            set_configvar('TIME_WITH_SYS_TIME', 1)
        end

        set_configvar('GETSERVBYPORT_R_ARGS', 6)
        set_configvar('GETSERVBYNAME_R_ARGS', 6)

        if get_configvar('HAVE_RES_SERVICENAME_IN_LIBRESOLV') then
            set_configvar('HAVE_LIBRESOLV', 1)
            set_configvar('CARES_USE_LIBRESOLV', 1)
        end
        local cares_headers = {
            'HAVE_SYS_TYPES_H',
            'HAVE_SYS_SOCKET_H',
            'HAVE_SYS_SELECT_H',
            'HAVE_WS2TCPIP_H',
            'HAVE_WINSOCK2_H',
            'HAVE_WINDOWS_H',
            'HAVE_ARPA_NAMESER_H',
            'HAVE_ARPA_NAMESER_COMPAT_H',
        }
        for _, cares_header in ipairs(cares_headers) do
            if get_configvar(cares_header) then
                set_configvar('CARES_'..cares_header, 1)
            end
        end
    end)
    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("cmake/ares_build.h.in", "cmake/ares_config.h.in")

    add_files(
        "src/lib/*.c",
        "src/lib/dsa/*.c",
        "src/lib/event/*.c",
        "src/lib/legacy/*.c",
        "src/lib/record/*.c",
        "src/lib/str/*.c",
        "src/lib/util/*.c"
    )
    add_defines("HAVE_CONFIG_H=1")
    add_includedirs("include", "src/lib/include", "src/lib")
    if is_plat("windows", "mingw") then
        add_files("src/lib/cares.rc")
    end
    add_headerfiles("include/*.h", "$(buildir)/config/ares_build.h")
    if is_kind("shared") then
        add_defines("CARES_BUILDING_LIBRARY")
    else
        add_defines("CARES_STATICLIB")
    end
