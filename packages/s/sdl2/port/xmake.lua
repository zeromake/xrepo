add_rules("mode.debug", "mode.release")

option("winrt")
    set_default(false)
    set_showmenu(true)
option_end()

option("x11")
    set_default(true)
    set_showmenu(true)
option_end()

option("wayland")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sdlMainSrc = {}
local sdlSrc = {
    "src/*.c",
    "src/atomic/*.c",
    "src/audio/*.c",
    "src/audio/dummy/*.c",
    "src/cpuinfo/*.c",
    "src/dynapi/*.c",
    "src/events/*.c",
    "src/file/*.c",
    "src/haptic/*.c",
    "src/hidapi/*.c",
    "src/joystick/*.c",
    "src/libm/*.c",
    "src/misc/*.c",
    "src/power/*.c",
    "src/render/*.c",
    "src/render/*/*.c",
    "src/sensor/*.c",
    "src/stdlib/*.c",
    "src/thread/*.c",
    "src/timer/*.c",
    "src/video/*.c",
    "src/video/yuv2rgb/*.c",
    "src/locale/*.c",
    "src/audio/disk/*.c",
    "src/video/x11/*.c",
    "src/joystick/hidapi/*.c",
    "src/joystick/virtual/*.c",
}


if is_plat("macosx") then
    table.join2(sdlMainSrc, {
        'src/main/dummy/*.c'
    })
    table.join2(sdlSrc, {
        "src/power/macosx/*.c",
        "src/video/cocoa/*.m",
        "src/render/metal/*.m",
        "src/misc/macosx/*.m",
        "src/locale/macosx/*.m",
        "src/audio/coreaudio/*.m",
        "src/joystick/iphoneos/*.m",
        "src/filesystem/cocoa/*.m",
        "src/file/cocoa/*.m",
        "src/thread/pthread/*.c",
        "src/core/unix/*.c",
        "src/timer/unix/*.c",
        "src/loadso/dlopen/*.c",
        "src/haptic/darwin/*.c",
        "src/joystick/darwin/*.c",
        "src/sensor/dummy/*.c",
        "src/video/dummy/*.c",
    })
elseif is_plat("iphoneos") then
    table.join2(sdlMainSrc, {
        'src/main/uikit/*.c'
    })
    table.join2(sdlSrc, {
        "src/power/uikit/*.m",
        "src/video/uikit/*.m",
        "src/render/metal/*.m",
        "src/misc/ios/*.m",
        "src/audio/coreaudio/*.m",
        "src/joystick/iphoneos/*.m",
        "src/joystick/steam/*.c",
        "src/timer/unix/*.c",
        "src/thread/pthread/*.c",
        "src/sensor/coremotion/*.m",
        "src/haptic/dummy/*.c",
        "src/video/dummy/*.c",
        "src/loadso/dlopen/*.c",
        "src/file/cocoa/*.m"
    })
elseif is_plat("windows", "mingw") then
    table.join2(sdlSrc, {
        "src/video/windows/*.c",
        "src/audio/wasapi/*.c",
        "src/audio/winmm/*.c",
        "src/audio/directsound/*.c",
        "src/filesystem/windows/*.c",
        "src/core/windows/*.c",
        "src/timer/windows/*.c",
        "src/loadso/windows/*.c",
        "src/haptic/windows/*.c",
        "src/joystick/windows/*.c",
        "src/power/windows/*.c",
        "src/sensor/windows/*.c",
        "src/sensor/dummy/*.c",
        "src/video/dummy/*.c",
    })
    if get_config("winrt") then
        table.join2(sdlMainSrc, {
            'src/main/winrt/*.cpp'
        })
        table.join2(sdlSrc, {
            "src/audio/wasapi/*.cpp",
            "src/core/winrt/*.cpp",
            "src/filesystem/winrt/*.cpp",
            "src/misc/winrt/*.cpp",
            "src/power/winrt/*.cpp",
            "src/render/direct3d11/*.cpp",
            "src/thread/windows/SDL_syssem.c",
            "src/thread/stdcpp/*.cpp",
            "src/video/winrt/*.cpp",
            "src/locale/winrt/SDL_syslocale.c",
            "src/haptic/dummy/*.c",
        })
        add_requires("cppwinrt")
    else
        table.join2(sdlMainSrc, {
            'src/main/windows/*.c'
        })
        table.join2(sdlSrc, {
            "src/thread/generic/SDL_syscond.c",
            "src/thread/windows/*.c",
            "src/locale/windows/*.c",
            "src/misc/windows/*.c",
        })
    end
elseif is_plat("android") then
    table.join2(sdlMainSrc, {
        'src/main/android/*.c'
    })
    table.join2(sdlSrc, {
        "src/video/android/*.c",
        "src/misc/android/*.c",
        "src/audio/aaudio/*.c",
        "src/audio/openslES/*.c",
        "src/audio/android/*.c",
        "src/filesystem/android/*.c",
        "src/thread/pthread/*.c",
        "src/core/android/*.c",
        "src/timer/unix/*.c",
        "src/loadso/dlopen/*.c",
        "src/haptic/android/*.c",
        "src/hidapi/android/*.cpp",
        "src/joystick/android/*.c",
        "src/power/android/*.c",
        "src/sensor/android/*.c",
        "src/locale/android/*.c",
    })
    add_requires("ndk-cpufeatures", {system=false})
elseif is_plat("linux") then
    table.join2(sdlMainSrc, {
        'src/main/dummy/*.c'
    })
    table.join2(sdlSrc, {
        "src/core/unix/*.c",
        "src/core/linux/*.c",
        "src/audio/alsa/*.c",
        "src/audio/pulseaudio/*.c",
        "src/filesystem/unix/*.c",
        "src/haptic/linux/*.c",
        "src/hidapi/linux/*.c",
        "src/joystick/linux/*.c",
        "src/loadso/dlopen/*.c",
        "src/locale/unix/*.c",
        "src/misc/unix/*.c",
        "src/power/linux/*.c",
        "src/thread/pthread/*.c",
        "src/video/x11/*.c",
        "src/video/wayland/*.c",
        "src/video/dummy/*.c",
        "src/timer/unix/*.c",
        "src/joystick/steam/*.c",
        "src/joystick/dummy/*.c",
        "src/sensor/dummy/*.c",
    })
end

target("sdl2")
    set_kind("$(kind)")
    add_defines("HAVE_LIBC=1")
    if is_plat("windows", "mingw") then
        add_defines("SDL_THREAD_WINDOWS=1")
    end
    add_includedirs("include", "src/video/khronos")
    for _, f in ipairs(sdlSrc) do
        add_files(f)
    end
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
        add_defines(
            "SDL_FILESYSTEM_UNIX",
            "SDL_LOADSO_DLOPEN",
            "SDL_TIMER_UNIX",
            "SDL_HAPTIC_LINUX",
            "HAVE_LINUX_INPUT_H",
            "SDL_JOYSTICK_LINUX",
            "SDL_INPUT_LINUXEV",
            "HAVE_POLL",
            "HAVE_DBUS_DBUS_H",
            "SDL_USE_LIBDBUS"
        )
        add_cflags("-Wimplicit-function-declaration")
        add_cflags("-Wbuiltin-declaration-mismatch")
        if get_config("x11") then
            add_syslinks("X11", "Xext")
            add_defines(
                "SDL_VIDEO_DRIVER_X11",
                "SDL_VIDEO_DRIVER_X11_SUPPORTS_GENERIC_EVENTS"
            )
        elseif get_config("wayland") then
            add_defines(
                "SDL_VIDEO_DRIVER_WAYLAND",
                "SDL_VIDEO_DRIVER_WAYLAND_SUPPORTS_GENERIC_EVENTS"
            )
        end
        add_syslinks("pthread", "dl")
    elseif is_plat("windows", "mingw") then
        if is_kind("shared") then
            add_defines("DLL_EXPORT")
        end
        if get_config("winrt") then
            add_packages("cppwinrt")
            add_defines(
                "SDL_BUILDING_WINRT=1",
                "WINAPI_FAMILY=WINAPI_FAMILY_APP",
                "UNICODE",
                "_UNICODE"
            )
            add_syslinks(
                "msvcrt",
                "dxgi",
                "d3d11",
                "synchronization",
                "xinput",
                "mmdevapi"
            )
            -- support cx
            set_runtimes("MD")
            add_cxxflags("/ZW")
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
        add_packages("ndk-cpufeatures")
        add_defines("GL_GLEXT_PROTOTYPES", "ANDROID")
        add_syslinks("GLESv1_CM", "GLESv2", "OpenSLES", "log", "android")
    end
    add_headerfiles(path.join("include", "*.h"), {prefixdir="SDL2"})

target("sdl2_main")
    set_kind("$(kind)")
    add_includedirs("include")
    for _, f in ipairs(sdlMainSrc) do
        add_files(f)
    end
