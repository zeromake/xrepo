package("cpr")
    set_homepage("https://docs.libcpr.org/")
    set_description("C++ Requests is a simple wrapper around libcurl inspired by the excellent Python Requests project.")
    set_license("MIT")

    set_urls("https://github.com/libcpr/cpr/archive/refs/tags/$(version).tar.gz")

    add_versions("1.10.5", "c8590568996cea918d7cf7ec6845d954b9b95ab2c4980b365f582a665dea08d8")

    add_links("cpr")
    add_deps("curl")

    on_install(function (package)
        io.writefile("include/cpr/cprver.h", [[
#ifndef CPR_CPRVER_H
#define CPR_CPRVER_H
#define CPR_VERSION "1.10.5"
#define CPR_VERSION_MAJOR 1
#define CPR_VERSION_MINOR 10
#define CPR_VERSION_PATCH 5
#define CPR_VERSION_NUM 0x011005
#endif
]], {encoding = "binary"})
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

add_requires("curl")

set_languages("c++17")

target("cpr")
    set_kind("$(kind)")
    add_packages("curl")
    add_includedirs("include")
    add_headerfiles("include/cpr/*.h", {prefixdir = "cpr"})
    add_files("cpr/*.cpp")
]], {encoding = "binary"})
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <cassert>
            #include <cpr/cpr.h>
            static void test() {
                cpr::Response r = cpr::Get(cpr::Url{"https://xmake.io"});
                assert(r.status_code == 200);
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
