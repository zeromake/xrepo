add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("tweeny")
    set_kind("$(kind)")

    add_headerfiles("todo.h")
