package("fmt")
    set_homepage("https://fmt.dev")
    set_description("A modern formatting library")
    set_license("MIT")
    set_urls("https://github.com/fmtlib/fmt/releases/download/$(version)/fmt-$(version).zip")

    add_versions("10.2.1", "312151a2d13c8327f5c9c586ac6cf7cddc1658e8f53edae0ec56509c8fa516c9")
    add_versions("10.1.1", "b84e58a310c9b50196cda48d5678d5fa0849bca19e5fdba6b684f0ee93ed9d1b")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

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
