local function getVersion(version)
    local versions ={
        ["2024.10.05-alpha"] = "archive/1ca45c58912aaa2c02e0f143d36d7f171e5afbb5.tar.gz",
        ["2024.10.12-alpha"] = "archive/22566506d0679af649df01133af1b690458eb39d.tar.gz",
        ["2024.10.22-alpha"] = "archive/b0982e89828a4f18a203f1127da90ef8753a1b32.tar.gz",
        ["2024.10.24-alpha"] = "archive/4ea26a777104fcd59ddb49d77f4a91a66dee13c9.tar.gz",
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
    add_versions("2024.10.24-alpha", "efe10573b05f09703902bf35ef9a33cc396165935477762d249c931e9ef6b2bd")
    add_versions("2024.10.22-alpha", "a98668cba1d0a46dce5149c5c6928526d22686f5327a7458206069fadc9906bc")
    add_versions("2024.10.12-alpha", "30a9906a2ef9b1be72f1ca8baabdfd32b972e62bdd4a5c53005d612b09d76601")
    add_versions("2024.10.05-alpha", "0260c58b60e3eff82222dd436e7935bbadade831e55ce690a234d3ab7ea0d153")

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
