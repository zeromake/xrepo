if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

local sourceFiles = {
    "lib/*.c"
}

target("lz4")
    set_kind("$(kind)")

    if not is_kind("shared") then
        add_headerfiles("lib/lz4frame_static.h")
        add_headerfiles("lib/lz4file.h")
    elseif is_plat("windows", "mingw") and is_kind("shared") then
        add_defines("LZ4_DLL_EXPORT=1")
    end
    add_headerfiles("lib/lz4.h", "lib/lz4hc.h", "lib/lz4frame.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
