if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end
add_requires("sfparse")

configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cincludes("HAVE_SYS_ENDIAN_H", "sys/endian.h")
configvar_check_cincludes("HAVE_ENDIAN_H", "endian.h")
configvar_check_cincludes("HAVE_BYTESWAP_H", "byteswap.h")
configvar_check_cfuncs("HAVE_BE64TOH", "be64toh", {includes = {"byteswap.h"}})
configvar_check_ctypes("HAVE_SSIZE_T", "ssize_t", {includes = {"sys/types.h"}})
set_configvar("ssize_t", "int", {quote = false})
set_configvar("PACKAGE_VERSION", "1.2.0")
set_configvar("PACKAGE_VERSION_NUM", 0x010200)

target("nghttp3")
    set_kind("$(kind)")
    add_files("lib/*.c")
    add_packages("sfparse")
    add_includedirs("lib/includes", "$(buildir)")
    add_defines("HAVE_CONFIG_H")
    if is_kind("shared") then
        add_defines("BUILDING_NGHTTP3=1")
    else
        add_defines("NGHTTP3_STATICLIB=1")
    end
    add_configfiles("lib/includes/nghttp3/version.h.in", "config.h.in")
    add_headerfiles("$(buildir)/*.h", {prefixdir = "nghttp3"})
    add_headerfiles("lib/includes/nghttp3/*.h", {prefixdir = "nghttp3"})
