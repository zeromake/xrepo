local function getVersion(version)
    local versions ={
        ["2024.12.08-alpha"] = "archive/1d5d948ccf2b02cad806c56395cdc36c00f24599.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("sdl3")
    set_homepage("https://www.libsdl.org")
    set_description("Simple DirectMedia Layer")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL/$(version)", {version = getVersion})

    --insert version
    add_versions("2024.12.08-alpha", "a5e6f1bfedd2d798fded5077a5739ab1c961ba2dcccac91581cfa578909ed0df")

    if is_plat("macosx") then
        add_frameworks(
            "AppKit",
            "CoreAudio",
            "AudioToolbox",
            "Metal",
            "Foundation",
            "IOKit",
            "ForceFeedback",
            "Carbon",
            "GameController",
            "CoreHaptics",
            "QuartzCore",
            "AVFoundation",
            "CoreMedia"
        )
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
            "CoreMotion",
            "CoreBluetooth",
            "AVFoundation",
            "CoreMedia",
            "CoreVideo"
        )
    elseif is_plat("windows", "mingw") then
    elseif is_plat("android") then
        add_deps("ndk-cpufeatures")
        add_syslinks("GLESv2", "OpenSLES", "log", "android")
    end
    on_load(function (package)
        if package:is_plat("windows", "mingw") then
            if package:config("winrt") then
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
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
    on_test(function (package)
        assert(package:has_cfuncs("SDL_Init", {includes = "SDL3/SDL.h", configs = {defines = "SDL_MAIN_HANDLED"}}))
    end)
