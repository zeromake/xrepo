local function getVersion(version)
    local versions ={
        ["2024.05.17-alpha"] = "archive/961488b0dc992365adcc7f9c668da5e62afa3e00.tar.gz",
        ["2024.06.04-alpha"] = "archive/ca28bcb3b8c1e1f013bb9bbb5c2c435a2d7f2174.tar.gz",
        ["2024.09.14-alpha"] = "archive/27862907c65453e53828e9d892df81c8ce536ea7.tar.gz",
        ["2024.09.16-alpha"] = "archive/4f722d372ae7246f123762b0407cbec1e6e71d65.tar.gz",
        ["2024.09.30-alpha"] = "archive/7241dd9ec3585db5a8ca6b98cba205941788febe.tar.gz",
        ["2024.10.01-alpha"] = "archive/f351395c4638b201359f6b1689cce059078a170f.tar.gz",
        ["2024.10.05-alpha"] = "archive/1ca45c58912aaa2c02e0f143d36d7f171e5afbb5.tar.gz",
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
    add_versions("2024.10.05-alpha", "0260c58b60e3eff82222dd436e7935bbadade831e55ce690a234d3ab7ea0d153")
    add_versions("2024.10.01-alpha", "214304a07591fcfda809ff96a0b72d62a78791c6d68d7caf7b3c23267708a6fb")
    add_versions("2024.09.30-alpha", "d829997cdb6b3fba3088aac71d6d4e7a8344178091707770c36a09e1d0df5059")
    add_versions("2024.09.16-alpha", "4513a3b933380900a46e7bdc4fe41de5b2ed0144ca8bc20b9fe979697947e755")
    add_versions("2024.09.14-alpha", "b3b075667dad243cede5f51b22f21ce8881c79e19736a6ea8b3d8f3268225771")
    add_versions("2024.06.04-alpha", "08444a9e3c70e1f1ba16244eee66509691c28feb1473f7f0b4bd351976ebcb4c")
    add_versions("2024.05.17-alpha", "87598c22b564426fa2c2d5a6b52901a9ec55d2453ea6bf75869d783f9ad4af65")

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
