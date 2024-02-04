package("mimalloc")
    set_homepage("https://github.com/microsoft/mimalloc")
    set_description("mimalloc is a compact general purpose allocator with excellent performance.")
    set_license("MIT")
    set_urls("https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz")

    add_versions("2.1.2", "2b1bff6f717f9725c70bf8d79e4786da13de8a270059e4ba0bdd262ae7be46eb")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

target("mimalloc")
    set_kind("$(kind)")
    add_files("src/*.c|alloc-override.c|static.c|page-queue.c")
    add_files("src/prim/*.c")
    add_includedirs("include")
    add_headerfiles("include/*.h")
    if is_kind("shared") then
        add_defines("MI_SHARED_LIB", "MI_SHARED_LIB_EXPORT")
    else
        add_defines("MI_STATIC_LIB")
    end
    if is_plat("windows", "mingw") then
        add_syslinks("psapi", "shell32", "user32", "advapi32", "bcrypt")
    else
        add_syslinks("pthread")
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("mi_malloc", {includes = {"mimalloc.h"}}))
        assert(package:has_cfuncs("mi_free", {includes = {"mimalloc.h"}}))
    end)
