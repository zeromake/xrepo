local function getVersion(version)
    local versions ={
        ["2024.04.05-alpha"] = "archive/9907207e5def0fabdb60c443517b0d9e9d521393.tar.gz",
    }
    return versions[tostring(version)]
end

package("tinyexpr")
    set_homepage("https://github.com/codeplea/tinyexpr")
    set_description("tiny recursive descent expression parser, compiler, and evaluation engine for math expressions")
    set_license("ZLIB")
    set_urls("https://github.com/codeplea/tinyexpr/$(version)", {
        version = getVersion
    })

    add_versions("2024.04.05-alpha", "897e32058491d3a74d79847d3405cb4bd2de877aa8657dafe9916b8fb915f34d")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("tinyexpr")
    set_kind("$(kind)")
    add_files("tinyexpr.c")
    add_headerfiles("tinyexpr.h")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("te_print", {includes = {"tinyexpr.h"}}))
    end)
