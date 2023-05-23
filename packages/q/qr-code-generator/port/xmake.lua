add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
    set_languages("c++17")
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
