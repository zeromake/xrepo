local function getVersion(version)
    local versions = {
        ["2023.12.07-alpha"] = "archive/7e2c57b9648d140bee47bec9b74f9fe8eeca2663.tar.gz",
        ["2024.07.19-alpha"] = "archive/c072e53645e0bb75cd4ab1901df8df861874ac45.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("toml-c")
    set_homepage("https://github.com/arp242/toml-c")
    set_description("C library for parsing TOML 1.0.")
    set_license("MIT")
    set_urls("https://github.com/arp242/toml-c/$(version)", {
        version = getVersion
    })
    --insert version
    add_versions("2024.07.19-alpha", "b4e1e9042eca3e4928ee13187f1d14c5ee26b218a614a43877957a4f8f53e202")
    add_versions("2024.06.20-alpha", "d7ee1ef3a4cd9c98a234f19b4fe9a6985f713de5aeedaeecf0c589a613d29f90")
    add_versions("2023.12.07-alpha", "3ed7a1c5fb4f9f5e921aa8590277fc0985d79d64b7456cb40d7399317de9d1fc")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
target("toml-c")
    set_kind("$(kind)")
    add_files("toml.c")
    add_headerfiles("header/toml-c.h")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("toml_parse", {includes = {"toml-c.h"}}))
    end)
