local function getVersion(version)
    local versions ={
        ["2024.10.22-alpha"] = "archive/a4ab993fbeda78f56dc20e94e256fad6e38ef228.tar.gz",
        ["2024.11.04-alpha"] = "archive/f45378940601e777fad147c98023d65af153202e.tar.gz",
        ["2024.11.14-alpha"] = "archive/af41c7eed22c898d2f620e6da6a1477d250a24b5.tar.gz",
        ["2024.11.19-alpha"] = "archive/53ee60dd655a71353fad07fb505258c39222b264.tar.gz",
        ["2024.11.28-alpha"] = "archive/4a275c429260ec43f27c07a25cf18453a7e6dcd9.tar.gz",
        ["2025.02.07-alpha"] = "archive/67439217918510a4467306705b7d5d4bbf79317e.tar.gz",
        ["2025.02.19-alpha"] = "archive/441efb2789b3bef89cd7e580c40a84111ec77e81.tar.gz",
        ["2025.02.25-alpha"] = "archive/3ecf2de10226392ecb071c470bea9758a24cd6b1.tar.gz",
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
    add_versions("2025.02.25-alpha", "21f9197ca646f7067bcb56f6c28e684ed6b0f9cc049cbd4d1a2ded0af8c1296e")
    add_versions("2025.02.19-alpha", "af1c39f248975c38c1341e3960fe450335002850172552259a40822066132354")
    add_versions("2025.02.07-alpha", "4ad6e66c63595384e024ef01f7db1784acf177a6530642b0460d4cb1b691f4b0")
    add_versions("2024.11.28-alpha", "f1eb1935cbe62509861e9ae01e0c14ea9f69d95be2add4caa63e925971922921")
    add_versions("2024.11.19-alpha", "f9d8be5febeea23193c49f00c0ed33373821d36d8ed11d6f3fe7af748007f3cf")
    add_versions("2024.11.14-alpha", "c00a85b7a82ccde9adec70bb3da04b3e1ead7778d264226b578eac34995d1b97")
    add_versions("2024.11.04-alpha", "d7ef46623b4b5b9268ad863877beadfc32876a3ddfb7de5b13686b2f11444b44")
    add_versions("2024.10.22-alpha", "2ad052ff92f791894bcb6f89f700ddd213fc33429a2890ad22f19a7b7891f82e")

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
