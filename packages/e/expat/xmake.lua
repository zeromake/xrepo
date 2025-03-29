
package("expat")
    set_homepage("https://libexpat.github.io")
    set_description("expat is a stream-oriented XML parser library written in C.")
    set_license("MIT")
    set_urls("https://github.com/libexpat/libexpat/releases/download/R_$(version).tar.bz2", {version = function (version)
        return version:gsub("%.", "_") .. "/expat-" .. version
    end})

    --insert version
    add_versions("2.7.1", "45c98ae1e9b5127325d25186cf8c511fa814078e9efeae7987a574b482b79b3d")
    add_versions("2.7.0", "10f3e94896cd7f44de566cafa2e0e1f35e8df06d119b38d117c0e72d74a4b4b7")
    add_versions("2.6.4", "8dc480b796163d4436e6f1352e71800a774f73dbae213f1860b60607d2a83ada")
    add_versions("2.6.3", "b8baef92f328eebcf731f4d18103951c61fa8c8ec21d5ff4202fb6f2198aeb2d")
    add_versions("2.6.2", "9c7c1b5dcbc3c237c500a8fb1493e14d9582146dd9b42aa8d3ffb856a3b927e0")

    on_load(function (package)
        if package:config("shared") ~= true then
            package:add("defines", "XML_STATIC")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("expat_config.h.in", [[
${define _HOST_BIGENDIAN}

#if _HOST_BIGENDIAN == 1
#define BYTEORDER 4321
#else
#define BYTEORDER 1234
#endif

#define XML_CONTEXT_BYTES 1024
#define XML_DTD 1
#define XML_NS 1
#define XML_GE 1
#define PACKAGE "expat"
#define PACKAGE_BUGREPORT "expat-bugs@libexpat.org"
#define PACKAGE_NAME "expat"
#define PACKAGE_STRING "expat 2.4.8"
#define PACKAGE_TARNAME "expat"
#define PACKAGE_URL ""
#define PACKAGE_VERSION "2.4.8"
#define STDC_HEADERS 1
#define VERSION "2.4.8"
#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
/* #  undef WORDS_BIGENDIAN */
# endif
#endif
#if !defined(_WIN32)
#define XML_DEV_URANDOM 1
#endif

${define HAVE_ARC4RANDOM}
${define HAVE_ARC4RANDOM_BUF}
${define HAVE_GETPAGESIZE}
${define HAVE_GETRANDOM}
${define HAVE_MMAP}
${define HAVE_DLFCN_H}
${define HAVE_FCNTL_H}
${define HAVE_INTTYPES_H}
${define HAVE_MEMORY_H}
${define HAVE_INTTYPES_H}
${define HAVE_STDINT_H}
${define HAVE_STDLIB_H}
${define HAVE_STRINGS_H}
${define HAVE_STRING_H}
${define HAVE_SYS_PARAM_H}
${define HAVE_SYS_STAT_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_UNISTD_H}
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("XML_ParserCreate(NULL)", {includes = {"expat_external.h", "expat.h"}}))
    end)
