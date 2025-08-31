package("cpr")
    set_homepage("https://docs.libcpr.org/")
    set_description("C++ Requests is a simple wrapper around libcurl inspired by the excellent Python Requests project.")
    set_license("MIT")

    set_urls("https://github.com/libcpr/cpr/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("1.12.0", "f64b501de66e163d6a278fbb6a95f395ee873b7a66c905dd785eae107266a709")
    add_versions("1.11.2", "3795a3581109a9ba5e48fbb50f9efe3399a3ede22f2ab606b71059a615cd6084")
    add_versions("1.11.1", "e84b8ef348f41072609f53aab05bdaab24bf5916c62d99651dfbeaf282a8e0a2")
    add_versions("1.11.0", "fdafa3e3a87448b5ddbd9c7a16e7276a78f28bbe84a3fc6edcfef85eca977784")
    add_versions("1.10.5", "c8590568996cea918d7cf7ec6845d954b9b95ab2c4980b365f582a665dea08d8")
    add_versions("1.9.9", "79a9fc30ac41f54becfa2110744a4091bedce6cf65eec2ef04523337335b8690")

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

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

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
