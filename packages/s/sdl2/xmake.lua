package("sdl2")
    set_homepage("https://www.libsdl.org")
    set_description("Simple DirectMedia Layer")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL/releases/download/release-$(version)/SDL2-$(version).tar.gz")

    --insert version
    add_versions("2.32.6", "6a7a40d6c2e00016791815e1a9f4042809210bdf10cc78d2c75b45c4f52f93ad")
    add_versions("2.32.4", "f15b478253e1ff6dac62257ded225ff4e7d0c5230204ac3450f1144ee806f934")
    add_versions("2.32.2", "c5f30c427fd8107ee4a400c84d4447dd211352512eaf0b6e89cc6a50a2821922")
    add_versions("2.32.0", "f5c2b52498785858f3de1e2996eba3c1b805d08fe168a47ea527c7fc339072d0")
    add_versions("2.30.11", "8b8d4aef2038533da814965220f88f77d60dfa0f32685f80ead65e501337da7f")
    add_versions("2.30.10", "f59adf36a0fcf4c94198e7d3d776c1b3824211ab7aeebeb31fe19836661196aa")
    add_versions("2.30.9", "24b574f71c87a763f50704bbb630cbe38298d544a1f890f099a4696b1d6beba4")
    add_versions("2.30.8", "380c295ea76b9bd72d90075793971c8bcb232ba0a69a9b14da4ae8f603350058")

    add_configs("winrt", {description = "Support winrt", default = false, type = "boolean"})
    add_configs("bmp_compat", {description = "Support bmp save use compat", default = false, type = "boolean"})

    if is_plat("macosx") then
        add_frameworks(
            "OpenGL",
            "CoreVideo",
            "CoreAudio",
            "AudioToolbox",
            "Carbon",
            "CoreGraphics",
            "ForceFeedback",
            "Metal",
            "AppKit",
            "IOKit",
            "CoreFoundation",
            "Foundation",
            "CoreHaptics",
            "GameController"
        )
        add_syslinks("iconv")
    elseif is_plat("iphoneos") then
        add_frameworks(
            "AVFAudio",
            "AudioToolbox",
            "UIKit",
            "Metal",
            "CoreGraphics",
            "QuartzCore",
            "OpenGLES",
            "CoreHaptics",
            "GameController",
            "CoreMotion"
        )
    elseif is_plat("linux", "bsd") then
        add_deps("cmake")
        if is_plat("bsd") then
            add_syslinks("usbhid")
        end
        add_syslinks("pthread", "dl", "X11", "Xext")
    end
    add_includedirs("include")
    add_includedirs("include/SDL2")
    add_links("sdl2")
    if is_plat("android") then
        add_deps("ndk-cpufeatures")
        add_syslinks("OpenSLES", "log", "android")
    elseif is_plat("linux") then
        add_links("SDL2")
    end

    on_load(function (package)
        if package:is_plat("macosx") and package:version():ge("2.0.14") then
            package:add("frameworks", "CoreHaptics", "GameController")
        end
        if package:is_plat("windows", "mingw") then
            if package:config("winrt") then
                package:add("deps", "cppwinrt")
                package:add(
                    "syslinks",
                    "msvcrt",
                    "dxgi",
                    "d3d11",
                    "synchronization",
                    "xinput",
                    "mmdevapi"
                )
            else
                package:add(
                    "syslinks",
                    "gdi32",
                    "user32",
                    "winmm",
                    "shell32",
                    "setupapi",
                    "advapi32",
                    "version",
                    "ole32",
                    "cfgmgr32",
                    "imm32",
                    "oleaut32"
                )
            end
        end
    end)

    on_install(function (package)
        local configs = {}
        local packagedeps = {}
        if package:is_plat("linux") then
            table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
            table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
            import("package.tools.cmake").install(package, configs, {packagedeps = packagedeps})
        else
            os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
            configs["winrt"] = package:config("winrt") and "y" or "n"
            configs["bmp_compat"] = package:config("bmp_compat") and "y" or "n"
            import("package.tools.xmake").install(package, configs)
        end
        os.cp("android-project/app/src/main/java/org/libsdl/app/*.java", package:installdir("lib/org.libsdl.app"))
    end)

    -- use msbuild
    -- on_install(function (package)
    --     local content = io.readfile("VisualC-WinRT\\SDL-UWP.vcxproj"):gsub("v142", "v143")
    --     io.writefile("VisualC-WinRT\\SDL-UWP.vcxproj", content)
    --     local configs = {"VisualC-WinRT\\SDL-UWP.vcxproj", "/p:Configuration=Release", "/p:Platform=x64"}
    --     import("package.tools.msbuild").build(package, configs)
    --     os.cp("include/*.h", package:installdir("include").."/")
    --     os.cp("VisualC-WinRT/x64/Release/SDL-UWP/*.dll", package:installdir("bin"))
    --     os.cp("VisualC-WinRT/x64/Release/SDL-UWP/*.lib", package:installdir("lib"))
    --     os.cp("VisualC-WinRT/x64/Release/SDL-UWP/*.pdb", package:installdir("lib"))
    -- end)

    on_test(function (package)
        if not package:is_plat("android") then
            assert(package:has_cfuncs("SDL_Init", {includes = "SDL2/SDL.h", configs = {defines = "SDL_MAIN_HANDLED"}}))
        end
    end)
