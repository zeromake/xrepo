local options = {}

package("gif")
    set_homepage("https://giflib.sourceforge.net")
    set_description("GIFLIB is a package of portable tools and library routines for working with GIF images.")
    set_license("MIT")
    set_urls("https://download.sourceforge.net/giflib/giflib-$(version).tar.gz")
    
    add_versions("5.2.1", "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        if package:is_plat("windows") then
            io.writefile("unistd.h", [[
#ifndef _UNISTD_H
#define _UNISTD_H
#include <io.h>
#include <process.h>
#endif /* _UNISTD_H */]])
        end
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    -- end)
