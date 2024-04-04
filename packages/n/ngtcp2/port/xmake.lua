if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

add_requires("libressl")

target("ngtcp2")
    set_kind("$(kind)")
    add_packages("libressl")
    add_includedirs("$(buildir)")
    add_includedirs("lib/includes")
    add_includedirs("crypto/includes")
    add_includedirs("crypto")
    add_includedirs("lib")
    set_configvar("PACKAGE_VERSION", "1.4.0")
    set_configvar("PACKAGE_VERSION_NUM", 0x010400)
    add_configfiles("lib/includes/ngtcp2/version.h.in")
    add_configfiles("config.h.in")
    add_defines("HAVE_CONFIG_H")
    if is_kind("shared") then
        add_defines("BUILDING_NGTCP2=1")
    else
        add_defines("NGTCP2_STATICLIB=1")
    end
    add_headerfiles("lib/includes/ngtcp2/*.h", {prefixdir = "ngtcp2"})
    add_headerfiles("$(buildir)/*.h", {prefixdir = "ngtcp2"})
    add_headerfiles("crypto/includes/ngtcp2/*.h", {prefixdir = "ngtcp2"})
    configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
    configvar_check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")
    configvar_check_cincludes("HAVE_NETINET_IP_H", "netinet/ip.h")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_cincludes("HAVE_SYS_ENDIAN_H", "sys/endian.h")
    configvar_check_cincludes("HAVE_ENDIAN_H", "endian.h")
    configvar_check_cincludes("HAVE_BYTESWAP_H", "byteswap.h")
    configvar_check_cincludes("HAVE_ASM_TYPES_H", "asm/types.h")
    configvar_check_cincludes("HAVE_LINUX_NETLINK_H", "linux/netlink.h")
    configvar_check_cincludes("HAVE_LINUX_RTNETLINK_H", "linux/rtnetlink.h")
    configvar_check_cfuncs("HAVE_BE64TOH", "be64toh", {includes = {"byteswap.h"}})
    configvar_check_cfuncs("HAVE_EXPLICIT_BZERO", "explicit_bzero", {includes = {"strings.h"}})
    configvar_check_cfuncs("HAVE_MEMSET_S", "memset_s", {includes = {"string.h"}})
    configvar_check_ctypes("HAVE_SSIZE_T", "ssize_t", {includes = {"sys/types.h"}})
    set_configvar("ssize_t", "long long", {quote = false})
    add_files("lib/*.c")
    add_files("crypto/*.c")
    add_files("crypto/quictls/*.c")
