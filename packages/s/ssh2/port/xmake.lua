if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

option("quictls")
    set_default(false)
    set_showmenu(true)
option_end()
option("libressl")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

if get_config("quictls") then
    add_requires("quictls")
elseif get_config("libressl") then
    add_requires("libressl")
end

function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_SYS_SELECT_H", "sys/select.h")
configvar_check_cincludes("HAVE_SYS_UIO_H", "sys/uio.h")
configvar_check_cincludes("HAVE_SYS_SOCKET_H", "sys/socket.h")
configvar_check_cincludes("HAVE_SYS_IOCTL_H", "sys/ioctl.h")
configvar_check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
configvar_check_cincludes("HAVE_SYS_UN_H", "sys/un.h")
configvar_check_cincludes("HAVE_SYS_PARAM_H", "sys/param.h")
configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
configvar_check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")

configvar_check_cfuncs("HAVE_GETTIMEOFDAY", "gettimeofday", {includes = "sys/types.h"})
configvar_check_cfuncs("HAVE_STRTOLL", "strtoll", {includes = "stdlib.h"})
configvar_check_cfuncs("HAVE_STRTOI64", "_strtoi64", {includes = "stdlib.h"})
configvar_check_cfuncs("HAVE_SNPRINTF", "snprintf", {includes = "stdio.h"})
configvar_check_cfuncs("HAVE_EXPLICIT_BZERO", "explicit_bzero", {includes = "string.h"})
configvar_check_cfuncs("HAVE_EXPLICIT_MEMSET", "explicit_memset", {includes = "string.h"})
configvar_check_cfuncs("HAVE_MEMSET_S", "memset_s", {includes = "string.h"})

configvar_check_cincludes("HAVE_POLL", "poll", {includes = {"poll.h"}})
configvar_check_cincludes("HAVE_SELECT", "select", {includes = {"sys/select.h"}})

configvar_check_csymbol_exists("HAVE_O_NONBLOCK", "O_NONBLOCK", {includes = {"fcntl.h"}})
configvar_check_csymbol_exists("HAVE_FIONBIO", "FIONBIO", {includes = {"sys/ioctl.h"}})
configvar_check_csnippets("HAVE_IOCTLSOCKET_CASE", [[
#include <sys/ioctl.h>
int main() {
    int socket;
    int flags = IoctlSocket(socket, FIONBIO, (long)1);
    return 0;
}]])
configvar_check_csymbol_exists("HAVE_SO_NONBLOCK", "SO_NONBLOCK", {includes = {"socket.h"}})
if not is_plat("windows", "mingw") then
    set_configvar("LIBSSH2_API", "__attribute__ ((__visibility__ (\"default\")))")
end

target("ssh2")
    set_kind("$(kind)")
    add_configfiles("src/libssh2_config.h.in")
    add_includedirs("$(buildir)", "include")
    add_headerfiles("include/*.h")
    add_files("src/*.c")
    if get_config("quictls") then
        add_packages("quictls")
    elseif get_config("libressl") then
        add_packages("libressl")
    end
    add_defines("HAVE_CONFIG_H","LIBSSH2_OPENSSL")
    if is_plat("windows", "mingw") then
        add_syslinks("user32")
    end
