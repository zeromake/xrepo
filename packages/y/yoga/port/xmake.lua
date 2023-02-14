add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

set_languages("c++11")

local sourceFiles = {
    "yoga/**.cpp"
}

target("yoga")
    set_kind("$(kind)")
    add_includedirs(".")
    add_headerfiles("yoga/*.h", {prefixdir = "yoga"})
    add_headerfiles("yoga/event/*.h", {prefixdir = "yoga/event"})
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
