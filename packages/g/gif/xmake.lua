package("gif")
    set_homepage("https://giflib.sourceforge.net")
    set_description("GIFLIB is a package of portable tools and library routines for working with GIF images.")
    set_license("MIT")
    set_urls("https://download.sourceforge.net/giflib/giflib-$(version).tar.gz")

    --insert version
    add_versions("5.2.2", "be7ffbd057cadebe2aa144542fd90c6838c6a083b5e8a9048b8ee3b66b29d5fb")
    add_versions("5.2.1", "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd")

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        if package:is_plat("windows") then
            io.writefile("unistd.h", [[
#ifndef _UNISTD_H
#define _UNISTD_H
#include <io.h>
#include <process.h>
#endif /* _UNISTD_H */]], {encoding = "binary"})
        end
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    -- end)
