local function getVersion(version)
    local versions ={
        ["2023.11.14"] = "archive/2c1fbe1967457c6b95323a5ea4136849c66bc307.tar.gz",
    }
    return versions[tostring(version)]
end


package("sdl3")
    set_homepage("https://www.libsdl.org")
    set_description("Simple DirectMedia Layer")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL/$(version)", {version = getVersion})

    add_versions("2023.11.14", "f6a239d22dad806ac7038e656aea9266f3e489139bfc5408625e4a92a359dbeb")

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
            "QuartzCore"
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
            "CoreBluetooth"
        )
    elseif is_plat("windows", "mingw") then
        if get_config("winrt") then
            add_syslinks(
                "msvcrt",
                "dxgi",
                "d3d11",
                "synchronization",
                "xinput",
                "mmdevapi"
            )
        else
            add_syslinks(
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
    elseif is_plat("android") then
        add_deps("ndk-cpufeatures")
        add_syslinks("GLESv2", "OpenSLES", "log", "android")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
    on_test(function (package)
        assert(package:has_cfuncs("SDL_Init", {includes = "SDL3/SDL.h", configs = {defines = "SDL_MAIN_HANDLED"}}))
    end)
