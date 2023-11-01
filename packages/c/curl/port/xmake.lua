includes("check_cincludes.lua")
includes("check_csnippets.lua")
includes("check_cfuncs.lua")
includes("check_ctypes.lua")
add_rules("mode.debug", "mode.release")

option("winrt")
    set_default(false)
    set_showmenu(true)
option_end()

add_requires("zlib", {system=false})
add_requires("wolfssl", {system=false})

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "lib/*.c",
    "lib/vtls/*.c",
    "lib/vauth/*.c",
    "lib/vquic/*.c"
}

function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

function configvar_check_csymbol_exists(define_name, var_name, opt)
    configvar_check_csnippets(define_name, 'void* a =(void*)'..var_name..';', opt)
end

target("curl")
    set_kind("$(kind)")

    if not is_plat("windows", "mingw", "macosx") then
        set_configdir("$(buildir)/config")
        add_includedirs("$(buildir)/config")
        add_configfiles("curl_config.h.in")

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
        configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")
        configvar_check_cincludes("HAVE_WINLDAP_H", "winldap.h")
        configvar_check_cincludes("HAVE_WINSOCK2_H", "winsock2.h")
        configvar_check_cincludes("HAVE_WS2TCPIP_H", "ws2tcpip.h")
        configvar_check_cincludes("HAVE_PROCESS_H", "process.h")
        configvar_check_cincludes("TIME_WITH_SYS_TIME", {"sys/time.h", "time.h"})

        configvar_check_cfuncs("HAVE_ALARM", "alarm", {includes={"unistd.h"}})
        configvar_check_cfuncs("HAVE_FTRUNCATE", "ftruncate", {includes={"unistd.h"}})
        configvar_check_cfuncs("HAVE_UTIME", "utime", {includes={"utime.h"}})
        configvar_check_cfuncs("HAVE_UTIMES", "utimes", {includes={"utime.h"}})
        configvar_check_cfuncs("HAVE_SIGACTION", "sigaction", {includes={"signal.h"}})
        configvar_check_cfuncs("HAVE_SIGACTION", "sigaction", {includes={"signal.h"}})
        configvar_check_cfuncs("HAVE_RAND_EGD", "RAND_egd", {includes={"openssl/rand.h"}})
        configvar_check_cfuncs("HAVE_IOCTLSOCKET", "ioctlsocket", {includes={"windows.h", "winsock.h"}})

        configvar_check_csymbol_exists("HAVE_IOCTLSOCKET_FIONBIO", "FIONBIO", {includes={"windows.h", "winsock.h"}})
        configvar_check_csymbol_exists("HAVE_FCNTL_O_NONBLOCK", "O_NONBLOCK", {includes={"fcntl.h"}})
        configvar_check_ctypes("HAVE_STRUCT_TIMEVAL", "struct timeval", {includes={"windows.h", "winsock.h"}})
        configvar_check_ctypes("HAVE_LONGLONG", "long long", {includes={"fcntl.h"}})

        configvar_check_sizeof("SIZEOF_INT", "int")
        configvar_check_sizeof("SIZEOF_SIZE_T", "size_t")
        configvar_check_sizeof("SIZEOF_CURL_OFF_T", 8)

        set_configvar("USE_MANUAL", 1)
        set_configvar("CURL_DISABLE_LDAP", 1)
        set_configvar("HAVE_SOCKET", 1)
        set_configvar("HAVE_SELECT", 1)
        set_configvar("OS", "xmake")
    end

    add_headerfiles("include/curl/*.h", {prefixdir = "curl"})

    add_includedirs("lib", "include")

    if is_plat("windows", "mingw") then
        -- set_configvar("HAVE_IOCTLSOCKET_FIONBIO", 1)
        if get_config("winrt") then
            add_defines("CURL_DISABLE_LDAP=1")
        else
            add_defines("USE_WIN32_LDAP=1")
            add_syslinks("wldap32")
        end
        add_defines("WIN32")
    elseif is_plat("macosx") then
        add_defines("HAVE_LONGLONG=1")
    end

    if not is_kind("shared") then
        add_defines("CURL_STATICLIB")
    end

    add_defines(
        "BUILDING_LIBCURL",
        "OPENSSL_EXTRA",
        "HAVE_CONFIG_H=1",
        "USE_WOLFSSL=1",
        "HAVE_LIBZ=1",
        "HAVE_ZLIB_H=1"
    )

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    add_packages("wolfssl", "zlib")

    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
