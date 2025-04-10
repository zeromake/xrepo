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
    add_versions("5.4.4", "9df65d5283ebce2b907cd72cfb2f97d3f162c143122e8d5e57f4da23ff129205")
    add_versions("5.4.3", "62959dbaedddee5786c45a2106b6d46ed6b88a5eaea6a7b670bedda97152d701")
    add_versions("5.4.2", "d3787bc97ae10f3d12bd286c49ca75e38808dd77dc502fa38dfaefa4ac5e2d89")
    add_versions("5.4.1", "e88380b9823721360c7379f7f9a4bab740617fd6caf42dbe427fa246752a3d68")
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
