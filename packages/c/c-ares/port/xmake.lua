includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

local function configvar_check_clibrary_exists(define_name, fun_name, library_name, opt)
    opt = opt or {}
    if library_name then
        opt.links = {library_name}
    end
    opt.defines = {"CHECK_FUNCTION_EXISTS="..fun_name}
    configvar_check_csnippets(define_name, [[
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
    ]], opt)
end

function CARES_FUNCTION_IN_LIBRARY(define_name, fun_name, lib_name, opt)
    configvar_check_clibrary_exists("NOT_"..define_name, fun_name)
    configvar_check_clibrary_exists(define_name, fun_name, lib_name, opt)
end

CARES_FUNCTION_IN_LIBRARY("HAVE_RES_SERVICENAME_IN_LIBRESOLV", "res_servicename", "resolv")

if is_plat("macosx", "iphoneos") then
    configvar_check_csnippets(IOS, [[
#include <stdio.h>
#include <TargetConditionals.h>

int main() {
    #if TARGET_OS_IPHONE == 0
    #error Not an iPhone target
    #endif
    return 0;
}
]])
    configvar_check_csnippets(IOS_V10, [[
#include <stdio.h>
#include <TargetConditionals.h>

int main() {
    #if TARGET_OS_IPHONE == 0 || __IPHONE_OS_VERSION_MIN_REQUIRED < 100000
    #  error Not iOS v10
    #endif
    return 0;
}
]])
    configvar_check_csnippets(MACOS_V1012, [[
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

if is_plat("windows", "mingw") then
    configvar_check_cincludes("HAVE_WINSOCK2_H", {"windows.h", "winsock2.h"})
    configvar_check_cincludes("HAVE_WS2TCPIP_H", {"windows.h", "winsock2.h", "ws2tcpip.h"})
    configvar_check_cincludes("HAVE_IPHLPAPI_H", {"windows.h", "winsock2.h", "iphlpapi.h"})
    configvar_check_cincludes("HAVE_NETIOAPI_H", {"windows.h", "winsock2.h", "netioapi.h"})
    configvar_check_cincludes("HAVE_MSWSOCK_H", {"windows.h", "winsock2.h", "mswsock.h"})
    configvar_check_cincludes("HAVE_WINSOCK_H", {"windows.h", "winsock.h"})
    configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")
    configvar_check_cincludes("HAVE_WINTERNL_H", {"windows.h", "winternl.h"})
    configvar_check_cincludes("HAVE_NTDEF_H", {"windows.h", "ntdef.h"})
    configvar_check_cincludes("HAVE_NTSTATUS_H", {"windows.h", "ntdef.h", "ntstatus.h"})
end

if is_plat("macosx", "iphoneos") then
    add_defines("_DARWIN_C_SOURCE")
elseif is_plat("linux", "android") then
    add_defines("_GNU_SOURCE", "_POSIX_C_SOURCE=200809L", "_XOPEN_SOURCE=700")
elseif is_plat("windows", "mingw") then
    add_defines(
        "WIN32_LEAN_AND_MEAN",
        "_CRT_SECURE_NO_DEPRECATE",
        "_CRT_NONSTDC_NO_DEPRECATE",
        "_WIN32_WINNT=0x0602"
    )
    add_syslinks("ws2_32", "advapi32", "iphlpapi")
end

target("c-ares")
    set_kind("$(kind)")
    add_headerfiles("todo.h")
