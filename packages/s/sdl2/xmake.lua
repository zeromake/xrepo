package("sdl2")
    set_homepage("https://www.libsdl.org")
    set_description("Simple DirectMedia Layer")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL/releases/download/release-$(version)/SDL2-$(version).tar.gz")

    add_versions("2.26.1", "02537cc7ebd74071631038b237ec4bfbb3f4830ba019e569434da33f42373e04")
    add_versions("2.24.1", "bc121588b1105065598ce38078026a414c28ea95e66ed2adab4c44d80b309e1b")

    add_configs("winrt", {description = "Support winrt", default = false, type = "boolean"})

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
            "Foundation"
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
        if is_plat("bsd") then
            add_syslinks("usbhid")
        end
        add_syslinks("pthread", "dl")
    end
    add_includedirs("include")
    if is_plat("android") then
        add_deps("ndk-cpufeatures")
        add_syslinks("GLESv1_CM", "GLESv2", "OpenSLES", "log", "android")
    end

    on_load(function (package)
        if package:is_plat("macosx") and package:version():ge("2.0.14") then
            package:add("frameworks", "CoreHaptics", "GameController")
        end
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
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        configs["winrt"] = package:config("winrt") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
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
            assert(package:has_cfuncs("SDL_Init", {includes = "SDL.h", configs = {defines = "SDL_MAIN_HANDLED"}}))
        end
    end)
