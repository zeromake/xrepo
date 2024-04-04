add_rules("mode.debug", "mode.release")

add_requires("eabase")

target("eastl")
    set_kind("$(kind)")
    set_languages("c++14")
    add_includedirs("include")
    add_packages("eabase")
    add_files("source/*.cpp")
    if is_plat("windows") then
        add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
        add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    end
