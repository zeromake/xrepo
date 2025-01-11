add_rules("mode.debug", "mode.release")

option("x11")
    set_default(true)
    set_showmenu(true)
option_end()

option("wayland")
    set_default(false)
    set_showmenu(true)
option_end()

option("bmp_compat")
    set_default(false)
    set_showmenu(true)
option_end()

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

if get_config("bmp_compat") then
    add_defines("LCS_WINDOWS_COLOR_SPACE=1")
end

local sdlMainSrc = {
    "src/main/*.c"
}

if is_plat("iphoneos") then
    table.join2(sdlMainSrc, {
        'src/main/ios/*.m'
    })
elseif is_plat("wasm") then
    table.join2(sdlMainSrc, {
        'src/main/emscripten/*.c'
    })
else
    table.join2(sdlMainSrc, {
        'src/main/generic/*.c'
    })
end

local sdlSrc = {
    "src/*.c",
    "src/core/*.c",
    "src/atomic/*.c",
    "src/audio/*.c",
    "src/audio/dummy/*.c",
    "src/cpuinfo/*.c",
    "src/dynapi/*.c",
    "src/events/*.c",
    "src/file/*.c",
    "src/file/generic/*.c",
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
    -- "src/video/x11/*.c",
    "src/joystick/hidapi/*.c",
    "src/joystick/virtual/*.c",
    "src/camera/SDL_camera.c",
    "src/camera/dummy/*.c",
    "src/filesystem/*.c",
    "src/storage/*.c",
    "src/storage/generic/*.c",
    "src/storage/steam/*.c",
    "src/time/*.c",
    "src/gpu/*.c",
    "src/gpu/vulkan/*.c",
    "src/process/*.c",
    "src/process/dummy/*.c",
    "src/video/offscreen/*.c",
    "src/main/*.c",
    "src/dialog/*.c",
    "src/tray/*.c",
}

if is_plat("windows", "mingw") then
    table.join2(sdlSrc, {
        "src/file/windows/*.c",
        "src/process/windows/*.c",
        "src/time/windows/*.c",
        "src/main/windows/*.c",
    })
else
    table.join2(sdlSrc, {
        "src/file/io_uring/*.c",
        "src/process/posix/*.c",
        "src/time/unix/*.c",
        "src/main/generic/*.c",
    })
end


if is_plat("macosx") then
    table.join2(sdlSrc, {
        "src/power/macos/*.c",
        "src/video/cocoa/*.m",
        "src/render/metal/*.m",
        "src/misc/macos/*.m",
        "src/locale/macos/*.m",
        "src/audio/coreaudio/*.m",
        "src/joystick/apple/*.m",
        "src/filesystem/cocoa/*.m",
        "src/filesystem/posix/*.c",
        "src/thread/pthread/*.c",
        "src/core/unix/*.c",
        "src/timer/unix/*.c",
        "src/loadso/dlopen/*.c",
        "src/haptic/darwin/*.c",
        "src/joystick/darwin/*.c",
        "src/sensor/dummy/*.c",
        "src/video/dummy/*.c",
        -- "src/hidapi/mac/*.c",
        "src/camera/coremedia/*.m",
        "src/gpu/metal/*.m",
        "src/dialog/cocoa/*.m",
        "src/tray/cocoa/*.m",
    })
elseif is_plat("iphoneos") then
    table.join2(sdlSrc, {
        "src/power/uikit/*.m",
        "src/video/uikit/*.m",
        "src/render/metal/*.m",
        "src/misc/ios/*.m",
        "src/audio/coreaudio/*.m",
        "src/filesystem/cocoa/*.m",
        "src/filesystem/posix/*.c",
        "src/joystick/apple/*.m",
        "src/joystick/steam/*.c",
        "src/timer/unix/*.c",
        "src/thread/pthread/*.c",
        "src/sensor/coremotion/*.m",
        "src/haptic/dummy/*.c",
        "src/video/dummy/*.c",
        "src/loadso/dlopen/*.c",
        "src/hidapi/ios/*.m",
        "src/locale/dummy/*.c",
        "src/camera/coremedia/*.m",
        "src/gpu/metal/*.m",
        "src/dialog/dummy/*.c",
    })
elseif is_plat("windows", "mingw") then
    table.join2(sdlSrc, {
        "src/video/windows/*.c",
        "src/audio/wasapi/*.c",
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
        "src/camera/mediafoundation/*.c",
        "src/gpu/d3d12/*.c",
        "src/dialog/windows/*.c",
        "src/thread/generic/SDL_syscond.c",
        "src/thread/generic/SDL_sysrwlock.c",
        "src/thread/windows/*.c",
        "src/locale/windows/*.c",
        "src/misc/windows/*.c",
        "src/tray/windows/*.c",
    })
elseif is_plat("android") then
    table.join2(sdlSrc, {
        "src/camera/android/*.c",
        "src/video/android/*.c",
        "src/misc/android/*.c",
        "src/audio/aaudio/*.c",
        "src/audio/openslES/*.c",
        "src/filesystem/android/*.c",
        "src/filesystem/posix/*.c",
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
        "src/dialog/unix/*.c",
        "src/tray/unix/*.c",
    })
    add_requires("ndk-cpufeatures")
elseif is_plat("linux") then
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
        "src/joystick/linux/*.c",
        "src/sensor/dummy/*.c",
        "src/dialog/unix/*.c",
        "src/tray/unix/*.c",
    })
end

target("sdl3")
    set_kind("$(kind)")
    add_defines("HAVE_LIBC=1")
    if is_plat("windows", "mingw") then
        add_defines("SDL_THREAD_WINDOWS=1")
    end
    add_includedirs("src", "include", "include/SDL3", "include/build_config")
    add_includedirs("src/video/khronos")
    for _, f in ipairs(sdlSrc) do
        add_files(f)
    end
    for _, f in ipairs(sdlMainSrc) do
        add_files(f)
    end
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
            "CoreMedia",
            "UniformTypeIdentifiers"
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
        add_defines(
            "UNICODE",
            "_UNICODE"
        )
        if is_kind("shared") then
            add_defines("DLL_EXPORT")
        end
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
    elseif is_plat("android") then
        add_packages("ndk-cpufeatures")
        add_defines("GL_GLEXT_PROTOTYPES", "ANDROID")
        add_syslinks("GLESv2", "OpenSLES", "log", "android")
    end
    add_headerfiles(path.join("include", "SDL3", "*.h"), {prefixdir="SDL3"})
