package("harfbuzz")
    set_homepage("https://harfbuzz.github.io/")
    set_description("HarfBuzz is a text shaping library.")

    set_license("MIT")
    set_urls("https://github.com/harfbuzz/harfbuzz/releases/download/$(version)/harfbuzz-$(version).tar.xz")
    add_versions("5.3.1", "4a6ce097b75a8121facc4ba83b5b083bfec657f45b003cd5a3424f2ae6b4434d")
    add_configs("freetype", {description = "Support freetype", default = false, type = "boolean"})

    add_includedirs("include")

    on_load(function (package)
        if package:config("freetype") then
            package:add("deps", "freetype")
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
option("use-freetype")
    set_default(false)
    set_showmenu(true)
option_end()

if has_config("use-freetype") then 
    add_requires("freetype")
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("harfbuzz")
    set_kind("$(kind)")
    add_defines("HAVE_ATEXIT=1", "HAVE_ISATTY=1", "HAVE_STDBOOL_H=1")
    if is_plat("windows", "mingw") then
        add_defines("HAVE_DIRECTWRITE=1")
    end
    if has_config("use-freetype") then 
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
]])
        local configs = {}
        local v = "n"
        if package:config("freetype") then
            v = "y"
        end
        table.insert(configs, "--use-freetype="..v)
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("hb_buffer_add_utf8", {includes = "hb.h"}))
    end)
