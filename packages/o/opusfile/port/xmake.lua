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

add_requires("ogg", "opus")

target("opusfile")
    set_kind("$(kind)")
    add_packages("ogg", "opus")
    add_includedirs("include")
    add_headerfiles("include/opusfile.h")
    add_files(
        "src/info.c",
        "src/internal.c",
        "src/opusfile.c",
        "src/stream.c"
    )
