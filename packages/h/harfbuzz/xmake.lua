package("harfbuzz")
    set_homepage("https://harfbuzz.github.io/")
    set_description("HarfBuzz is a text shaping library.")

    set_license("MIT")
    set_urls("https://github.com/harfbuzz/harfbuzz/releases/download/$(version)/harfbuzz-$(version).tar.xz")

    add_versions("9.0.0", "a41b272ceeb920c57263ec851604542d9ec85ee3030506d94662067c7b6ab89e")
    add_versions("8.5.0", "77e4f7f98f3d86bf8788b53e6832fb96279956e1c3961988ea3d4b7ca41ddc27")
    add_versions("8.4.0", "af4ea73e25ab748c8c063b78c2f88e48833db9b2ac369e29bd115702e789755e")
    add_versions("8.3.0", "109501eaeb8bde3eadb25fab4164e993fbace29c3d775bcaa1c1e58e2f15f847")
    add_versions("8.1.1", "0305ad702e11906a5fc0c1ba11c270b7f64a8f5390d676aacfd71db129d6565f")
    add_versions("5.3.1", "4a6ce097b75a8121facc4ba83b5b083bfec657f45b003cd5a3424f2ae6b4434d")
    add_configs("freetype", {description = "Support freetype", default = false, type = "boolean"})

    add_includedirs("include")

    on_load(function (package)
        if package:config("freetype") then
            package:add("deps", "freetype")
        end
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

set_languages("c++14")
option("freetype")
    set_default(false)
    set_showmenu(true)
option_end()

if has_config("freetype") then 
    add_requires("freetype")
end

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("harfbuzz")
    set_kind("$(kind)")
    add_defines("HAVE_ATEXIT=1", "HAVE_ISATTY=1", "HAVE_STDBOOL_H=1")
    if is_plat("windows", "mingw") then
        add_defines("HAVE_DIRECTWRITE=1")
    end
    if has_config("freetype") then 
        add_packages("freetype")
        add_defines("HAVE_FREETYPE")
    end
    add_headerfiles("src/*.h")
    add_headerfiles("src/*.hh")
    for _, f in ipairs({
        "src/harfbuzz.cc"
    }) do
        add_files(f)
    end
]], {encoding = "binary"})
        local configs = {}
        local v = "n"
        if package:config("freetype") then
            v = "y"
        end
        table.insert(configs, "--freetype="..v)
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     if not package:config("freetype") then
    --         assert(package:has_cfuncs("hb_buffer_add_utf8", {includes = "hb.h"}))
    --     end
    -- end)
