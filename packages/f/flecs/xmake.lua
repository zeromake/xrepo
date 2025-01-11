package("flecs")
    set_homepage("https://www.flecs.dev")
    set_description("A fast entity component system (ECS) for C & C++")
    set_license("MIT")
    set_urls("https://github.com/SanderMertens/flecs/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("4.0.4", "a3b6238a913f65d90db18759ab5442393901da914e4a9bfe30aa8823687dce86")
    add_versions("4.0.3", "feb5185bca93eeadeb641329bfa88adedf4bd7aea5a4d89ade055b65c3af0517")
    add_versions("4.0.2", "131b703c30f53e08e30f2bac8da657276350b3f324a3321f753c3a9eccaa3f63")
    add_versions("4.0.1", "d88928226b3a6e7ebc7c818db50b2fb5828021ed3bcd206c4e2a3b0406472d2b")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("flecs")
    set_kind("$(kind)")
    add_includedirs("include")
    add_files(
        "src/**.c"
    )
    if is_kind("shared") then
        add_defines("flecs_EXPORTS")
    else
        add_defines("flecs_STATIC")
    end
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32")
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        os.cp("include/*.h", package:installdir("include").."/")
        os.cp("include/flecs", package:installdir("include").."/")
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ecs_init_w_args", {includes = {"flecs.h"}}))
    end)
