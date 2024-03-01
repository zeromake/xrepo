package("flecs")
    set_homepage("https://www.flecs.dev")
    set_description("A fast entity component system (ECS) for C & C++")
    set_license("MIT")
    set_urls("https://github.com/SanderMertens/flecs/archive/refs/tags/v$(version).tar.gz")

    add_versions("3.2.11", "8ebc5f6f3ec7bbba30b0afe9d22f157437925772857ea1c6e4201eb5d31b4fe5")
    add_versions("3.2.9", "65d50d6058cd38308a0ad2a971afa9f64aef899ebf78d6a074d905922ec5fdf8")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("flecs")
    set_kind("$(kind)")
    add_includedirs("include")
    add_files(
        "src/**.c",
        "*.c"
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
