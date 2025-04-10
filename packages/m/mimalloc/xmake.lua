package("mimalloc")
    set_homepage("https://github.com/microsoft/mimalloc")
    set_description("mimalloc is a compact general purpose allocator with excellent performance.")
    set_license("MIT")
    set_urls("https://github.com/microsoft/mimalloc/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("3.0.3", "baf343041420e2924e1760bbbc0c111101c44e1cecb998e7951f646a957ee05f")
    add_versions("3.0.1", "6a514ae31254b43e06e2a89fe1cbc9c447fdbf26edc6f794f3eb722f36e28261")
    add_versions("2.1.7", "0eed39319f139afde8515010ff59baf24de9e47ea316a315398e8027d198202d")
    add_versions("2.1.6", "0ec960b656f8623de35012edacb988f8edcc4c90d2ce6c19f1d290fbb4872ccc")
    add_versions("2.1.2", "2b1bff6f717f9725c70bf8d79e4786da13de8a270059e4ba0bdd262ae7be46eb")

    on_load(function (package)
        if is_plat("windows", "mingw") then
            package:add("syslinks", "psapi", "shell32", "user32", "advapi32", "bcrypt")
        else
            package:add("syslinks", "pthread")
        end
    end)
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("mimalloc")
    set_kind("$(kind)")
    add_files("src/*.c|alloc-override.c|static.c|page-queue.c|free.c")
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
