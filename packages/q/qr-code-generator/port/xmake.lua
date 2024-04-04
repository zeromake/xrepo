add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    set_languages("c++14")
else
    set_languages("c++11")
end

target("qr-code-generator-c")
    set_kind("$(kind)")
    add_headerfiles("c/qrcodegen.h")
    add_files("c/qrcodegen.c")

target("qr-code-generator-cpp")
    set_kind("$(kind)")
    add_headerfiles("cpp/qrcodegen.hpp")
    add_files("cpp/qrcodegen.cpp")
