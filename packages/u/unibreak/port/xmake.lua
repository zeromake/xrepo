includes("@builtin/check")
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
    "linebreak.c",
    "linebreakdata.c",
    "linebreakdef.c",
    "wordbreak.c",
    "graphemebreak.c",
    "emojidef.c",
    "unibreakbase.c",
    "unibreakdef.c",
}

target("unibreak")
    set_kind("$(kind)")

    add_headerfiles(
        "src/linebreak.h",
        "src/unibreakbase.h"
    )

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(path.join("src", f))
    end
