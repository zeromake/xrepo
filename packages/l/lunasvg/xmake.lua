
package("lunasvg")
    set_homepage("https://github.com/sammycage/lunasvg")
    set_description("LunaSVG - SVG rendering library in C++")
    set_license("MIT")

    set_urls("https://github.com/sammycage/lunasvg/archive/refs/tags/v$(version).tar.gz")
    --insert version
    add_versions("3.2.1", "3420175c9632007edfcd0198001abc116c5c646af8e928d393cd029985cc4ee8")
    add_versions("3.2.0", "073629cf858bceff6fe938370d141ac7c0d21ce40acd4ffe1d56109b84d16e0d")
    add_versions("3.1.1", "90b9c821944b2cddb9ab4d0d1ccd043712a8b12db7dcdcf451663c04737e40e2")

    add_deps("plutovg")
    on_load("windows", function (package)
        if package:config("shared") then
            package:add("defines", "LUNASVG_SHARED")
        else
            package:add("defines", "LUNASVG_BUILD_STATIC")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <lunasvg.h>
            void test() {
                auto document = lunasvg::Document::loadFromFile("tiger.svg");
                auto bitmap = document->renderToBitmap();
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
