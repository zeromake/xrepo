local function getVersion(version)
    local versions ={
        ["2023.12.07-alpha"] = "archive/7e2c57b9648d140bee47bec9b74f9fe8eeca2663.tar.gz",
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
