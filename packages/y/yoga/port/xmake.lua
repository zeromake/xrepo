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
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
