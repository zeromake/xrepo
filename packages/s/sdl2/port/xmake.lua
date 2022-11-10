add_rules("mode.debug", "mode.release")

local sdlPath = os.scriptdir()
local sdlSrc = {
    "src/*.c",
    "src/atomic/*.c",
    "src/audio/*.c",
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
    "src/render/direct3d/*.c",
    "src/render/direct3d11/*.c",
    "src/render/direct3d12/*.c",
    "src/render/opengl/*.c",
    "src/render/opengles/*.c",
    "src/render/opengles2/*.c",
    "src/render/ps2/*.c",
    "src/render/software/*.c",
    "src/render/vitagxm/*.c",
    "src/sensor/*.c",
    "src/stdlib/*.c",
    "src/thread/*.c",
    "src/timer/*.c",
    "src/video/*.c",
    "src/video/yuv2rgb/*.c",
    "src/locale/*.c",
    "src/video/dummy/*.c",
    "src/audio/disk/*.c",
    "src/audio/dummy/*.c",
    "src/video/x11/*.c",
    "src/sensor/dummy/*.c",
    "src/joystick/hidapi/*.c",
    "src/joystick/virtual/*.c",
}


if is_plat("macos") then
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
    })
elseif is_plat("windows", "mingw") then
    table.join2(sdlSrc, {
        "src/video/windows/*.c",
        "src/misc/windows/*.c",
        "src/audio/wasapi/*.c",
        "src/audio/winmm/*.c",
        "src/audio/directsound/*.c",
        "src/filesystem/windows/*.c",
        "src/thread/generic/SDL_syscond.c",
        "src/thread/windows/*.c",
        "src/core/windows/*.c",
        "src/timer/windows/*.c",
        "src/loadso/windows/*.c",
        "src/haptic/windows/*.c",
        "src/joystick/windows/*.c",
        "src/power/windows/*.c",
        "src/sensor/windows/*.c",
        "src/locale/windows/*.c",
        "src/power/windows/*.c",
    })
end

target("sdl2")
    set_kind("$(kind)")
    add_defines("HAVE_LIBC=1")
    if is_plat("windows", "mingw") then
        add_defines("SDL_THREAD_WINDOWS=1")
    end
    add_includedirs(path.join(sdlPath, "include"), path.join(sdlPath, "src/video/khronos"))
    for _, f in ipairs(sdlSrc) do
        add_files(path.join(sdlPath, f))
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
    add_headerfiles(path.join("include", "*.h"))
