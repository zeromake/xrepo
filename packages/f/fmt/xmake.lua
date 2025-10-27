package("fmt")
    set_homepage("https://fmt.dev")
    set_description("A modern formatting library")
    set_license("MIT")
    set_urls("https://github.com/fmtlib/fmt/releases/download/$(version)/fmt-$(version).zip")

    --insert version
    add_versions("12.0.0", "1c32293203449792bf8e94c7f6699c643887e826f2d66a80869b4f279fb07d25")
    add_versions("11.2.0", "203eb4e8aa0d746c62d8f903df58e0419e3751591bb53ff971096eaa0ebd4ec3")
    add_versions("11.1.4", "49b039601196e1a765e81c5c9a05a61ed3d33f23b3961323d7322e4fe213d3e6")
    add_versions("11.1.3", "7df2fd3426b18d552840c071c977dc891efe274051d2e7c47e2c83c3918ba6df")
    add_versions("11.1.1", "a25124e41c15c290b214c4dec588385153c91b47198dbacda6babce27edc4b45")
    add_versions("11.1.0", "e32d42c6be8df768d744bf0e7d4d69c4ccdce0eda44292ba5265add817413f17")
    add_versions("11.0.2", "40fc58bebcf38c759e11a7bd8fdc163507d2423ef5058bba7f26280c5b9c5465")
    add_versions("11.0.1", "62ca45531814109b5d6cef0cf2fd17db92c32a30dd23012976e768c685534814")
    add_versions("11.0.0", "583ce480ef07fad76ef86e1e2a639fc231c3daa86c4aa6bcba524ce908f30699")
    add_versions("10.2.1", "312151a2d13c8327f5c9c586ac6cf7cddc1658e8f53edae0ec56509c8fa516c9")
    add_versions("10.1.1", "b84e58a310c9b50196cda48d5678d5fa0849bca19e5fdba6b684f0ee93ed9d1b")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("fmt")
    set_kind("$(kind)")
    add_includedirs("include")
    if is_plat("windows") then
        set_languages("c++14")
    else
        set_languages("c++11")
    end
    add_headerfiles("include/fmt/*.h", {prefixdir = "fmt"})
    add_files("src/*.cc|fmt.cc")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
