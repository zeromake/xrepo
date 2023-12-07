package("ravi")
    set_homepage("http://ravilang.github.io")
    set_description("Ravi is a dialect of Lua, featuring limited optional static typing, JIT and AOT compilers ")
    set_license("MIT")
    set_urls("https://github.com/dibyendumajumdar/ravi/archive/refs/tags/$(version).tar.gz")

    add_versions("1.0-beta11", "7730b264ded32d4b211b344c44ff4e3e92f1ee9ff6b2279ca3e15bb86c75ef6e")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile('ravicomp/include/ravicomp_export.h', [[
#ifndef RAVICOMP_EXPORT_H
#define RAVICOMP_EXPORT_H
#ifdef RAVICOMP_STATIC_DEFINE
#  define RAVICOMP_EXPORT
#  define RAVICOMP_NO_EXPORT
#else
#  ifndef RAVICOMP_EXPORT
#    ifdef ravicomp_EXPORTS
#      define RAVICOMP_EXPORT __attribute__((visibility("default")))
#    else
#      define RAVICOMP_EXPORT __attribute__((visibility("default")))
#    endif
#  endif
#  ifndef RAVICOMP_NO_EXPORT
#    define RAVICOMP_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif
#ifndef RAVICOMP_DEPRECATED
#  define RAVICOMP_DEPRECATED __attribute__ ((__deprecated__))
#endif
#ifndef RAVICOMP_DEPRECATED_EXPORT
#  define RAVICOMP_DEPRECATED_EXPORT RAVICOMP_EXPORT RAVICOMP_DEPRECATED
#endif
#ifndef RAVICOMP_DEPRECATED_NO_EXPORT
#  define RAVICOMP_DEPRECATED_NO_EXPORT RAVICOMP_NO_EXPORT RAVICOMP_DEPRECATED
#endif
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef RAVICOMP_NO_DEPRECATED
#    define RAVICOMP_NO_DEPRECATED
#  endif
#endif
#endif /* RAVICOMP_EXPORT_H */
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
