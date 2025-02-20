
package("lunasvg")
    set_homepage("https://github.com/sammycage/lunasvg")
    set_description("LunaSVG - SVG rendering library in C++")
    set_license("MIT")

    set_urls("https://github.com/sammycage/lunasvg/archive/refs/tags/v$(version).tar.gz")
    --insert version
    add_versions("3.2.0", "073629cf858bceff6fe938370d141ac7c0d21ce40acd4ffe1d56109b84d16e0d")
    add_versions("3.1.1", "90b9c821944b2cddb9ab4d0d1ccd043712a8b12db7dcdcf451663c04737e40e2")
    add_versions("3.1.0", "2e05791bcc7c30c77efc4fee23557c5c4c9ccd4cf626a3167c0b4a4a316ae2b6")
    add_versions("3.0.1", "39e3f47d4e40f7992d7958123ca1993ff1a02887539af2af1c638da2855a603c")
    add_versions("3.0.0", "075f0a049ff205ce059feb1fe3ac0e826a1ac62d2360cb72463395f68c4c8764")
    add_versions("2.4.1", "db9d2134c8c2545694e71e62fb0772a7d089fe53e1ace1e08c2279a89e450534")
    add_versions("2.4.0", "0682c60501c91d75f4261d9c1a5cd44c2c9da8dba76f8402eab628448c9a4591")
    add_versions("2.3.9", "088bc9fd1191a004552c65bdcc260989b83da441b0bdaa965e79d984feba88fa")
    add_versions("2.3.8", "54d697e271a5aca36f9999d546b1b346e98a8183140027330f69a3eb0c184194")
    add_versions("2.3.5", "350ff56aa1acdedefe2ad8a4241a9fb8f9b232868adc7bd36dfb3dbdd57e2e93")

    add_deps("cmake")
    on_load("windows", function (package)
        if package:config("shared") then
            package:add("defines", "LUNASVG_SHARED")
        end
    end)

    on_install(function (package)
        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
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
