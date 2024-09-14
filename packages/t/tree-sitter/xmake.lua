package("tree-sitter")
    set_homepage("https://tree-sitter.github.io/")
    set_description("An incremental parsing system for programming tools")
    set_license("MIT")
    set_urls("https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v$(version).tar.gz")

    add_versions("0.23.0", "6403b361b0014999e96f61b9c84d6950d42f0c7d6e806be79382e0232e48a11b")
    add_versions("0.22.6", "e2b687f74358ab6404730b7fb1a1ced7ddb3780202d37595ecd7b20a8f41861f")
    add_versions("0.22.5", "6bc22ca7e0f81d77773462d922cf40b44bfd090d92abac75cb37dbae516c2417")
    add_versions("0.21.0", "6bb60e5b63c1dc18aba57a9e7b3ea775b4f9ceec44cc35dac4634d26db4eb69c")
    add_versions("0.20.8", "6181ede0b7470bfca37e293e7d5dc1d16469b9485d13f13a605baec4a8b1f791")
    on_install(function (package)
        io.writefile('xmake.lua', [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("tree-sitter")
    set_kind("$(kind)")
    add_files("lib/src/lib.c")
    add_includedirs("lib/src", "lib/include")
    add_headerfiles("lib/include/tree_sitter/*.h", {prefixdir = "tree_sitter"})
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
