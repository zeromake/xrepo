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

function string.split(input, delimiter)
    if (delimiter == "") then return false end
    local pos, arr = 0, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local packages = {
    sdl2="sdl2",
    sdlrenderer="sdl2",
    glfw="glfw",
    glut="freeglut"
}

local backend = get_config("backend")
if backend and backend ~= "" then
    local backends = string.split(backend, ";")
    for _, backend in ipairs(backends) do
        if packages[backend] ~= nil then
            add_requires(backend)
        end
    end
end

target("imgui")
    set_kind("$(kind)")
    add_files("*.cpp|imgui_demo.cpp")
    add_includedirs(".")
    local backend = get_config("backend")
    if backend and backend ~= "" then
        local backends = string.split(backend, ";")
        for _, backend in ipairs(backends) do
            if packages[backend] ~= nil then
                add_packages(backend)
            end
            add_headerfiles("backends/imgui_impl_"..backend..".h", {prefixdir = "backends"})
            if backend == "metal" or backend == "osx" then
                add_files("backends/imgui_impl_"..backend..".mm")
            else
                add_files("backends/imgui_impl_"..backend..".cpp")
            end
        end
    end
    if get_config("freetype") then
        add_defines("IMGUI_ENABLE_FREETYPE")
        add_packages("freetype")
        add_files("misc/freetype/*.cpp")
    end
    add_headerfiles("imgui.h", "imconfig.h")
