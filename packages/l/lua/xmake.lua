package("lua")
    set_homepage("https://lua.org")
    set_description("Lua is a powerful, efficient, lightweight, embeddable scripting language.")
    set_license("MIT")
    set_urls("https://www.lua.org/ftp/lua-$(version).tar.gz")

    add_versions("5.4.6", "7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88")
    if is_plat("linux", "android") then
        add_defines("LUA_USE_LINUX")
    elseif is_plat("macosx") then
        add_defines("LUA_USE_MACOSX")
    elseif is_plat("iphoneos") then
        add_defines("LUA_USE_IOS")
    elseif is_plat("windows") then
        add_defines("LUA_USE_WINDOWS")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
