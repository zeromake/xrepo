package("xxd")
    set_kind("binary")
    set_homepage("https://github.com/ckormanyos/xxd")
    set_description("hex-dump-type utility xxd")
    set_license("BSL-1.0")
    set_urls("https://github.com/ckormanyos/xxd/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.1", "5bedfa8245a11c415b5799d18e8a39a3a5008c15a0d83d34afd951a4406774fa")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("xxd")
    add_files("src/*.c")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
