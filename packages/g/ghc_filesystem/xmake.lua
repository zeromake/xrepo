package("ghc_filesystem")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/gulrak/filesystem")
    set_description("An implementation of C++17 std::filesystem for C++11 /C++14/C++17/C++20 on Windows, macOS, Linux and FreeBSD.")
    set_license("MIT")
    set_urls("https://github.com/gulrak/filesystem/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.5.14", "e783f672e49de7c5a237a0cea905ed51012da55c04fbacab397161976efc8472")
    add_versions("1.5.12", "7d62c5746c724d28da216d9e11827ba4e573df15ef40720292827a4dfd33f2e9")

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
target("ghc_filesystem")
    set_kind("headeronly")
    add_headerfiles("include/ghc/*.hpp", {prefixdir = "ghc"})
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets([[
namespace fs = ghc::filesystem;
void test() {
    fs::path dir(".");
    for (auto f : fs::directory_iterator(dir)) {
    }
}]], {includes = {"ghc/filesystem.hpp"}, configs = {languages = "c++17"}}))
    end)
