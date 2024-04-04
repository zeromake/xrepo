add_rules("mode.debug", "mode.release")

add_requires("freetype")
add_requires("harfbuzz")
add_requires("fribidi")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

local sourceFiles = {
    "src/raqm.c"
}

target("raqm")
    set_kind("$(kind)")

    add_headerfiles("src/raqm.h")

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")

    add_configfiles("config.h.in", "raqm-version.h.in")
    if is_kind("shared") then
        local sharedExport = "__attribute__((visibility(\"default\")))"
        if is_plat("windows", "mingw") then
            sharedExport = "__declspec(dllexport)"
        end
        set_configvar("RAQM_API", sharedExport, {quote = false})
    end
    -- set_configvar("RAQM_SHEENBIDI", 1)

    add_packages("freetype", "harfbuzz", "fribidi")
    add_defines("HAVE_CONFIG_H")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
