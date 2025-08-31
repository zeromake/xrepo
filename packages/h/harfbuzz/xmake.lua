package("harfbuzz")
    set_homepage("https://harfbuzz.github.io/")
    set_description("HarfBuzz is a text shaping library.")

    set_license("MIT")
    set_urls("https://github.com/harfbuzz/harfbuzz/releases/download/$(version)/harfbuzz-$(version).tar.xz")

    --insert version
    add_versions("11.4.5", "0f052eb4ab01d8bae98ba971c954becb32be57d7250f18af343b1d27892e03fa")
    add_versions("11.2.1", "093714c8548a285094685f0bdc999e202d666b59eeb3df2ff921ab68b8336a49")
    add_versions("11.2.0", "50f7d0a208367e606dbf6eecc5cfbecc01a47be6ee837ae7aff2787e24b09b45")
    add_versions("11.0.1", "4a7890090538136db64742073af4b4d776ab8b50e6855676a8165eb8b7f60b7a")
    add_versions("10.4.0", "480b6d25014169300669aa1fc39fb356c142d5028324ea52b3a27648b9beaad8")
    add_versions("9.0.0", "a41b272ceeb920c57263ec851604542d9ec85ee3030506d94662067c7b6ab89e")
    add_versions("8.5.0", "77e4f7f98f3d86bf8788b53e6832fb96279956e1c3961988ea3d4b7ca41ddc27")
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
