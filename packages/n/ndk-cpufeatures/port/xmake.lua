add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

target("cpufeatures")
    set_kind("$(kind)")
    local ndkDir = get_config("ndk")
    if ndkDir ~= nil then
        add_files(path.join(ndkDir, "sources/android/cpufeatures/*.c"))
        add_includedirs(path.join(ndkDir, "sources/android/cpufeatures"))
        add_headerfiles(path.join(ndkDir, "sources/android/cpufeatures/*.h"))
    end
