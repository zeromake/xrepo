add_rules("mode.debug", "mode.release")

if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")

add_requires(
    "sdl3",
    "spirv_cross",
    "directx_shader_compiler",
    "zeromake.rules"
)

target("shadercross")
    set_kind("binary")
    add_includedirs("include")
    add_files(
        "src/SDL_shadercross.c",
        "src/cli.c"
    )
    add_packages(
        "sdl3",
        "spirv_cross",
        "directx_shader_compiler",
        "zeromake.rules"
    )
    add_rules("@zeromake.rules/export_shared", {dir = "export_shared"})
    add_defines("SDL_SHADERCROSS_DXC=1")
    if is_plat("windows", "mingw") then
        add_files("src/version.rc")
    end
