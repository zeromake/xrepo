package("wepoll")
    set_homepage("https://github.com/piscisaureus/wepoll")
    set_description("wepoll: fast epoll for windows🎭")
    set_license("MIT")
    set_urls("https://github.com/piscisaureus/wepoll/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.5.8", "3f68e5f2f5a35c2eb641b73a6d0e605668ea66e5bd9ff1e170660e3b2a60c74e")
    add_syslinks("ws2_32")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
target("wepoll")
    set_kind("$(kind)")
    add_files("wepoll.c")
    add_headerfiles("wepoll.h", {prefixdir = "wepoll"})
    add_defines("WEPOLL_EXPORT=__declspec(dllexport)")
    add_syslinks("ws2_32")
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("epoll_create", {includes = {"wepoll/wepoll.h"}}))
    end)
