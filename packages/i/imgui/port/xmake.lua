add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
    set_languages("c++14")
else
    set_languages("c++11")
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
    sdl2renderer="sdl2",
    sdl="sdl2",
    sdlrenderer="sdl2",
    glfw="glfw",
    glut="freeglut"
}

local backend = get_config("backend")
if backend and backend ~= "" then
    local backends = string.split(backend, ";")
    for _, item in ipairs(backends) do
        if packages[item] ~= nil then
            add_requires(item)
        end
    end
end

target("imgui")
    set_kind("$(kind)")
    add_files("*.cpp|imgui_demo.cpp")
    add_includedirs(".")
    local backend = get_config("backend")
    on_config(function (target)
        local pkgs = target:pkgs()
        for n, v in pairs(pkgs) do
            if n == "freetype" then
                local includedir = path.join(v:get("sysincludedirs"), "freetype2")
                if os.exists(path.join(includedir, "ft2build.h")) then
                    target:add("includedirs", includedir)
                end
            end
        end
    end)
    if backend and backend ~= "" then
        local backends = string.split(backend, ";")
        for _, item in ipairs(backends) do
            if packages[item] ~= nil then
                add_packages(item)
            end
            add_headerfiles("backends/imgui_impl_"..item..".h", {prefixdir = "imgui/backends"})
            if item == "metal" or item == "osx" then
                add_files("backends/imgui_impl_"..item..".mm")
            else
                add_files("backends/imgui_impl_"..item..".cpp")
            end
        end
    end
    if get_config("freetype") then
        add_defines("IMGUI_ENABLE_FREETYPE")
        add_packages("freetype")
        add_files("misc/freetype/*.cpp")
        add_headerfiles("misc/freetype/imgui_freetype.h", {prefixdir = "imgui/misc/freetype"})
    end
    add_headerfiles("imgui.h", {prefixdir = "imgui"})
    add_headerfiles("imconfig.h", {prefixdir = "imgui"})

target("binary_to_compressed_c")
    set_plat(os.host())
    set_arch(os.arch())
    add_files("misc/fonts/binary_to_compressed_c.cpp")
