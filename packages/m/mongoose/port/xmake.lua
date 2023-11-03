if xmake.version():ge("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

target("mongoose")
    set_kind("$(kind)")

    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
