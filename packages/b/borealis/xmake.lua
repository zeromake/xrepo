local function getVersion(version)
    local versions ={
        ["2025.02.25-alpha"] = "archive/3ecf2de10226392ecb071c470bea9758a24cd6b1.tar.gz",
        ["2025.04.05-alpha"] = "archive/fac8e7ff747b1b96ce62ee7c567f23b7af346503.tar.gz",
        ["2025.04.10-alpha"] = "archive/9b0a06322c300b5ac07eae97d7fc266e8261ebaf.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("borealis")
    set_homepage("https://github.com/xfangfang/borealis")
    set_description("Hardware accelerated, Nintendo Switch inspired UI library for PC, Android, iOS, PSV, PS4 and Nintendo Switch")
    set_license("Apache-2.0")

    set_urls("https://github.com/xfangfang/borealis/$(version)", {
        version = getVersion
    })
    --insert version
    add_versions("2025.04.10-alpha", "50bf3fda37aa9b2d410f5933a773a459ee62953cbe0719a558b6d20cc4379d36")
    add_versions("2025.04.05-alpha", "22375f10ee2234b83ca684d9cb0c94f3b0f54796e36ae514237fefba8c250979")
    add_versions("2025.02.25-alpha", "21f9197ca646f7067bcb56f6c28e684ed6b0f9cc049cbd4d1a2ded0af8c1296e")

    add_configs("window", {description = "use window lib", default = "glfw", type = "string"})
    add_configs("driver", {description = "use driver lib", default = "opengl", type = "string"})
    add_configs("winrt", {description = "use winrt api", default = false, type = "boolean"})
    add_deps(
        "nanovg",
        "yoga =2.0.1",
        "nlohmann_json",
        "fmt",
        "tweeny",
        "stb",
        "tinyxml2"
    )
    add_includedirs("include")
    if is_plat("windows") then
        add_includedirs("include/compat")
        add_syslinks("wlanapi", "iphlpapi", "ws2_32")
    elseif is_plat("linux") then
        add_deps("dbus")
    end
    on_load(function (package)
        local window = package:config("window")
        local driver = package:config("driver")
        local winrt = package:config("winrt")
        if window == "glfw" then
            package:add("deps", "xfangfang_glfw")
        elseif window == "sdl" then
            package:add("deps", "sdl2")
        end
        if driver == "opengl" then
            package:add("deps", "glad =0.1.36")
        elseif driver == "d3d11" then
            package:add("syslinks", "d3d11")
        end
        if winrt then
            package:add("syslinks", "windowsapp")
        end
    end)
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        configs["window"] = package:config("window")
        configs["driver"] = package:config("driver")
        configs["winrt"] = package:config("winrt") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
        os.cp("library/include/*", package:installdir("include").."/")
        os.rm(package:installdir("include/borealis/extern"))
        os.cp("library/include/borealis/extern/libretro-common", package:installdir("include").."/")
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <borealis.hpp>

            static void test() {
                volatile void* i = (void*)&brls::Application::init;
                if (i) {};
            }
        ]]}, {
            configs = {languages = "c++20", defines = { "BRLS_RESOURCES=\".\"" }},
        }))
    end)
