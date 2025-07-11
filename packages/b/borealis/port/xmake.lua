add_rules("mode.debug", "mode.release")

option("platfrom")
    set_default("desktop")
    set_showmenu(true)
option_end()

option("window")
    set_default("glfw")
    set_showmenu(true)
option_end()

option("driver")
    set_default("opengl")
    set_showmenu(true)
option_end()

option("winrt")
    set_default(false)
    set_showmenu(true)
option_end()

option("unity_build")
    set_default(false)
    set_showmenu(true)
option_end()


local platform_resources_path = "\"./resources/\""

if is_plat("windows") then
    set_languages("c++20")
    add_cxflags("/utf-8")
    add_defines("NOMINMAX", "WIN32_LEAN_AND_MEAN")
    add_includedirs("library/include/compat")
    if is_mode("release") then
        set_optimize("faster")
    end
else
    set_languages("c++17")
end
if is_plat("mingw") then
    add_defines("WINVER=0x0605")
elseif is_plat("switch") then 
    -- You need to use this toolchain https://github.com/PoloNX/xmake-devkitpro
    add_repositories("switch-repo https://github.com/PoloNX/switch-repo")
    add_requires("libnx")
    platform_resources_path="\"romfs:/\""
elseif is_plat("linux") then 
    add_requires("dbus")
end

add_requires("tinyxml2")
add_requires("yoga =2.0.1")
add_requires("stb")
add_requires("nanovg")
add_requires("nlohmann_json")
add_requires("fmt")
add_requires("tweeny")

add_defines(
    'BRLS_RESOURCES='..platform_resources_path,
    "YG_ENABLE_EVENTS"
)

if get_config("driver") == "opengl" then
    add_requires("glad =0.1.36")
end

if get_config("window") == "sdl" then
    if get_config("winrt") then
        add_requires("sdl2", {configs={shared=true,winrt=true}})
        add_requires("cppwinrt")
    else
        add_requires("sdl2")
    end
elseif get_config("window") == "glfw" then
    add_requires("xfangfang_glfw")
elseif get_config("window") == "nanovg" and is_plat("switch") then 
    add_requires("deko3d")
end

target("borealis")
    set_kind("$(kind)")
    add_includedirs("library/include")
    add_includedirs("library/include/borealis/extern")
    add_files("library/lib/core/**.cpp")
    add_files("library/lib/views/**.cpp")
    add_files("library/lib/extern/libretro-common/**.c")

    local window = get_config("window")
    local driver = get_config("driver")


    if is_plat("switch") then 
        add_defines("__SWITCH__", "HAVE_LIBNX", "SWITCH", "STBI_NO_THREAD_LOCALS")
        add_files("library/lib/extern/switch-libpulsar/**.c")
        add_files("library/lib/platforms/switch/*.cpp")
        add_includedirs("library/lib/extern/switch-libpulsar/include")
        if window == "glfw" then 
            remove_files("library/lib/platforms/switch/switch_video.cpp")
            add_files("library/lib/platforms/glfw/glfw_video.cpp")
            add_packages("xfangfang_glfw")
            add_defines("__GLFW__")
        elseif window == "sdl" then 
            remove_files("library/lib/platforms/switch/switch_video.cpp")
            add_files("library/lib/platforms/sdl/sdl_video.cpp")
            add_packages("sdl2")
            add_defines("SDL_PLATFORM_UNIX")
        elseif window == "nanovg" then 
            add_files("library/lib/extern/nanovg/**.cpp")
            add_files("library/lib/extern/nanovg/nanovg.c")
            add_includedirs("library/include/borealis/extern/nanovg")
            add_packages("deko3d")
            add_defines("BOREALIS_USE_DEKO3D")
        end 

        if driver == "opengl" then 
            add_defines("BOREALIS_USE_OPENGL")
            add_files("library/lib/extern/glad/glad.c")
            add_includedirs("library/include/borealis/extern/glad")
        end 
        add_packages("libnx")
    elseif is_plat("windows") or is_plat("linux") or is_plat("macosx") then
        if window == "glfw" then
            add_files("library/lib/platforms/glfw/*.cpp")
            add_files("library/lib/platforms/desktop/*.cpp")
            add_packages("xfangfang_glfw")
            add_defines("__GLFW__")
        elseif window == "sdl" then
            add_files("library/lib/platforms/sdl/*.cpp")
            add_files("library/lib/platforms/desktop/*.cpp")
            add_packages("sdl2")
            if get_config("winrt") then
                add_defines("SDL_VIDEO_DRIVER_WINRT")
                add_packages("cppwinrt")
            end
            add_defines("__SDL2__")
        end

        if driver == "metal" then
            add_defines("BOREALIS_USE_METAL")
            add_frameworks("Metal", "MetalKit", "QuartzCore")
            add_files("library/lib/platforms/glfw/driver/metal.mm")
            add_links("nanovg_metal")
        elseif driver == "opengl" then
            add_defines("BOREALIS_USE_OPENGL")
            add_packages("glad")
        elseif driver == "d3d11" then
            add_files("library/lib/platforms/driver/d3d11.cpp", {unity_group = "d3d11"})
            if get_config("winrt") then
                add_defines("__WINRT__=1")
            end
            add_defines("BOREALIS_USE_D3D11")
            add_syslinks("d3d11")
            -- d3d11 可以开启可变帧率
            -- add_defines("__ALLOW_TEARING__=1")
        end

        if is_plat("macosx") then
            add_frameworks("SystemConfiguration", "CoreWlan")
            add_files("library/lib/platforms/desktop/desktop_darwin.mm")
        elseif is_plat("linux") then 
            add_packages("dbus")
        end
    end
    
    add_packages("tinyxml2", "nlohmann_json", "nanovg", "fmt", "tweeny", "yoga", "stb")
    add_defines("BOREALIS_USE_STD_THREAD")

    if get_config("unity_build") then
        add_rules("c++.unity_build", {batchsize = 16})
        add_rules("c.unity_build", {batchsize = 16})
    end
