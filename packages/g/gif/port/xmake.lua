if xmake.version():ge("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

local options = {}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op, {system=false})
    end
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "dgif_lib.c",
    "egif_lib.c",
    "gifalloc.c",
    "gif_err.c",
    "gif_font.c",
    "gif_hash.c",
    "openbsd-reallocarray.c",
}

target("gif")
    set_kind("$(kind)")

    add_includedirs(".")

    add_headerfiles(
        "gif_hash.h",
        "gif_lib.h",
        "gif_lib_private.h"
    )
    if is_plat("windows") then
        add_headerfiles("unistd.h")
    end
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
