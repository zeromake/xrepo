local function getVersion(version)
    local versions ={
        ["2024.04.23-alpha"] = "archive/2c76f6bf1cd0b0d375d617de62ba9ada93e09457.tar.gz",
        ["2024.05.09-alpha"] = "archive/1e96a73727a688e2d68c6a0dd9cd7b1fd3ac461c.tar.gz",
        ["2024.07.03-alpha"] = "archive/5432d309100457f70e280fd0117c07153bf39c71.tar.gz",
        ["2024.09.12-alpha"] = "archive/74a9a2a4402e6e62865cb720b6b708474fd0ed87.tar.gz",
        ["2024.09.19-alpha"] = "archive/f5cf3318f05d9fda1eff8644e311be8997085463.tar.gz",
        ["2024.10.08-alpha"] = "archive/c2cd87dc149fc16a6a949f8f9b4dc24c8739e2da.tar.gz",
        ["2024.10.20-alpha"] = "archive/4252593bcf05be593db879ee71f19a5f0837952b.tar.gz",
        ["2024.10.22-alpha"] = "archive/a4ab993fbeda78f56dc20e94e256fad6e38ef228.tar.gz",
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
    add_versions("2024.10.22-alpha", "2ad052ff92f791894bcb6f89f700ddd213fc33429a2890ad22f19a7b7891f82e")
    add_versions("2024.10.20-alpha", "da4f748aabf37cf1d7f236c7ddbf5f7d69208b50f50043d66b443a80403da173")
    add_versions("2024.10.08-alpha", "38a120bf53485dfb93efd1364c1e99078410e2449ff202fc18f3dfb99125d7b1")
    add_versions("2024.09.19-alpha", "07c4b674af280c3ed105b1fd09c6587b24977dbff67b1036a6d84ee86ab12d34")
    add_versions("2024.09.12-alpha", "e6684f38aa9b440abc5de5ebe5df7257e1ea836705fa5328f32edc261cb71b16")
    add_versions("2024.07.03-alpha", "329876658bfb0f87f252bf2620d1008d2cc8bbd217ac3636829103a3b1c3a6a4")
    add_versions("2024.05.09-alpha", "b007734e31ecda924809081e92e77ee6d4155a1c2232ebb05e49d143557964fc")
    add_versions("2024.04.23-alpha", "e9a7b2e7b90871b76f5b2133f90052032bda4002eae424706d083c9d40a02772")

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
