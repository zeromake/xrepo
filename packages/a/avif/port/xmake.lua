add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("codec")
    set_default("dav1d")
    set_showmenu(true)
option_end()


local codec = get_config("codec")
if codec == "dav1d" then
    add_requires("dav1d")
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
