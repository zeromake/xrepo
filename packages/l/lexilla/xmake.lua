local function getVersion(version)
    return tostring(version):gsub("%.", "")
end
package("lexilla")
    set_homepage("https://www.scintilla.org/Lexilla.html")
    set_description("Lexilla is a free library of language lexers that can be used with the Scintilla editing component.")
    set_license("MIT")
    set_urls("https://www.scintilla.org/lexilla$(version).tgz", {
        version = getVersion
    })

    --insert version
    add_versions("5.3.2", "fc06be954401c9dc1810f927bccd2604c43a70cf98178161cf817e95c4ebf00f")
    add_deps("scintilla")
    on_install(function (package)

        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
add_requires("scintilla")

if is_plat("windows") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("lexilla")
    set_kind("$(kind)")
    set_languages("c++17")
    add_packages("scintilla")
    add_files("src/*.cxx")
    add_files("lexlib/*.cxx")
    add_files("lexers/*.cxx")
    add_includedirs("include", "lexlib")
    add_headerfiles("include/*.h")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
