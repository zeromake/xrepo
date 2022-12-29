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
    "sqlite3.c",
}

target("sqlite3")
    set_kind("$(kind)")

    add_headerfiles(
        "sqlite3.h",
        "sqlite3ext.h"
    )

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
