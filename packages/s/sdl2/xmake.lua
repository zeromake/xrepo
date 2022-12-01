package("sdl2")
    set_homepage("https://www.libsdl.org")
    set_description("Simple DirectMedia Layer")
    set_license("zlib")
    set_urls("https://github.com/libsdl-org/SDL/releases/download/release-$(version)/SDL2-$(version).tar.gz")

    add_versions("2.24.1", "bc121588b1105065598ce38078026a414c28ea95e66ed2adab4c44d80b309e1b")

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
    elseif is_plat("linux", "bsd") then
        if is_plat("bsd") then
            add_syslinks("usbhid")
        end
        add_syslinks("pthread", "dl")
    elseif is_plat("windows", "mingw") then
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
    add_includedirs("include")

    on_load(function (package)
        if package:is_plat("macosx") and package:version():ge("2.0.14") then
            package:add("frameworks", "CoreHaptics", "GameController")
        end
    end)
    on_install("windows", "mingw", "macosx", "linux", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)
    on_test(function (package)
        assert(package:has_cfuncs("SDL_Init", {includes = "SDL.h", configs = {defines = "SDL_MAIN_HANDLED"}}))
    end)
