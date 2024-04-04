add_rules("mode.debug", "mode.release")

local options = {
    "yuv",
    "webp"
}


if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

option("codec")
    set_default("dav1d")
    set_showmenu(true)
option_end()


local codec = get_config("codec")
if codec == "dav1d" then
    add_requires("dav1d")
end

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op)
    end
end

target("avif")
    set_kind("$(kind)")
    add_files("src/*.c|codec_avm.c|codec_aom.c|codec_dav1d.c|codec_libgav1.c|codec_rav1e.c|codec_svt.c")
    add_includedirs("include")
    add_headerfiles("include/avif/avif.h", {prefixdir = "avif"})
    local codec = get_config("codec")
    if codec == "dav1d" then
        add_defines("AVIF_CODEC_DAV1D=1")
        add_files("src/codec_dav1d.c")
        add_packages("dav1d")
    end
    if is_kind("shared") then
        add_defines("AVIF_DLL=1")
        add_defines("AVIF_BUILDING_SHARED_LIBS=1")
    end
    
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
            if op == "yuv" then
                add_defines("AVIF_LIBYUV_ENABLED=1")
            elseif op == "webp" then
                add_defines("AVIF_LIBSHARPYUV_ENABLED=1")
            end
        end
    end
