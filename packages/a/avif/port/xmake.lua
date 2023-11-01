add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("codec")
    set_default("dav1d")
    set_showmenu(true)
option_end()


target("avif")
    set_kind("$(kind)")
