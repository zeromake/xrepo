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
        ]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        if package:is_plat("iphoneos") then
            local n = 0
            local file = io.open(path.join(package:installdir("include/ghc"), "filesystem.hpp"), "wb")
            for line in io.lines("include/ghc/filesystem.hpp") do
                local space, variable = line:match('(%s+).*std::find%(.*, ?(preferred_separator)%)')
                -- if line == '    using path_helper_base<value_type>::preferred_separator;' then
                --     file:write(line..'\n')
                --     file:write('    const static value_type __global_preferred_separator = preferred_separator;\n')
                if variable then
                    n = n + 1
                    file:write(space..'auto __preferred_separator_'..n..' = preferred_separator;\n')
                    line = line:gsub(', ?preferred_separator%)', ', __preferred_separator_'..n..')')
                    file:write(
                        line..'\n'
                    )
                else
                    file:write(line..'\n')
                end
            end
            file:close()
        end
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
