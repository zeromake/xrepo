add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

option("backend")
    set_default("")
    set_showmenu(true)
option_end()

option("freetype")
    set_default(false)
    set_showmenu(true)
option_end()

if get_config("freetype") then
    add_requires("freetype")
end

target("imgui")
    set_kind("$(kind)")
    add_files("*.cpp|imgui_demo.cpp")
    add_includedirs(".")
    -- if is_plat("windows", "mingw") then
    --     add_files("backends/imgui_impl_win32.cpp")
    -- elseif is_plat("macosx") then
    --     add_files("backends/imgui_impl_osx.mm")
    -- elseif is_plat("android") then
    --     add_files("backends/imgui_impl_android.cpp")
    -- end
    local backend = get_config("backend")
    if backend and backend ~= "" then
        if backend == "metal" then
            add_files("backends/imgui_impl_metal.mm")
        else
            add_files("backends/imgui_impl_"..backend..".cpp")
        end
    end
    if get_config("freetype") then
        add_defines("IMGUI_ENABLE_FREETYPE")
        add_packages("freetype")
        add_files("misc/freetype/*.cpp")
    end
    add_headerfiles("imgui.h", "imconfig.h")
