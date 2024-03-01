package("tree-sitter")
    set_homepage("https://tree-sitter.github.io/")
    set_description("An incremental parsing system for programming tools")
    set_license("MIT")
    set_urls("https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v$(version).tar.gz")

    add_versions("0.21.0", "6bb60e5b63c1dc18aba57a9e7b3ea775b4f9ceec44cc35dac4634d26db4eb69c")
    add_versions("0.20.8", "6181ede0b7470bfca37e293e7d5dc1d16469b9485d13f13a605baec4a8b1f791")
    on_install(function (package)
        io.writefile('xmake.lua', [[
add_rules("mode.debug", "mode.release")

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
