package("tree-sitter")
    set_homepage("https://tree-sitter.github.io/")
    set_description("An incremental parsing system for programming tools")
    set_license("MIT")
    set_urls("https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.25.3", "862fac52653bc7bc9d2cd0630483e6bdf3d02bcd23da956ca32663c4798a93e3")
    add_versions("0.25.2", "26791f69182192fef179cd58501c3226011158823557a86fe42682cb4a138523")
    add_versions("0.25.1", "99a2446075c2edf60e82755c48415d5f6e40f2d9aacb3423c6ca56809b70fe59")
    add_versions("0.24.6", "03c7ee1e6f9f4f3821fd4af0ae06e1da60433b304a73ff92ee9694933009121a")
    add_versions("0.24.5", "b5ac48acf5a04fd82ccd4246ad46354d9c434be26c9606233917549711e4252c")
    add_versions("0.24.4", "d704832a6bfaac8b3cbca3b5d773cad613183ba8c04166638af2c6e5dfb9e2d2")
    add_versions("0.24.3", "0a8d0cf8e09caba22ed0d8439f7fa1e3d8453800038e43ccad1f34ef29537da1")
    add_versions("0.24.1", "7adb5bb3b3c2c4f4fdc980a9a13df8fbf3526a82b5c37dd9cf2ed29de56a4683")
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
