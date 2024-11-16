local function getVersion(version)
    local versions ={
        ["2024.10.30-alpha"] = "archive/24bdbb8bf401ce99cc488e1eecf659774dad7b60.tar.gz",
        ["2024.11.05-alpha"] = "archive/588e32ea5af69193e19bd8b1ca81aa4a085a1623.tar.gz",
        ["2024.11.16-alpha"] = "archive/572cc7af634ba713b5523ff25cca71307f7b6c65.tar.gz",
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
    add_versions("2024.11.16-alpha", "f4bc978bbc47167c9543f894a6fa2db46193b652a4f796cf7d8c4ba0457af94a")
    add_versions("2024.11.05-alpha", "594064a6432c9ce33d3d8b53a92d81c6db1c1f031b47ddbdff643a9de77237df")
    add_versions("2024.10.30-alpha", "b052e388efc72b33693fd97e47145437e2c191c926fab58b0b4580a1d6ac842d")

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
