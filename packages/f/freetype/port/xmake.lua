if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

local freetypeFiles = {
    "src/autofit/autofit.c",
    "src/base/ftbase.c",
    "src/base/ftbbox.c",
    "src/base/ftbdf.c",
    "src/base/ftbitmap.c",
    "src/base/ftcid.c",
    "src/base/ftfstype.c",
    "src/base/ftgasp.c",
    "src/base/ftglyph.c",
    "src/base/ftgxval.c",
    "src/base/ftinit.c",
    "src/base/ftmm.c",
    "src/base/ftotval.c",
    "src/base/ftpatent.c",
    "src/base/ftpfr.c",
    "src/base/ftstroke.c",
    "src/base/ftsynth.c",
    "src/base/fttype1.c",
    "src/base/ftwinfnt.c",
    "src/bdf/bdf.c",
    "src/cache/ftcache.c",
    "src/cff/cff.c",
    "src/cid/type1cid.c",
    "src/dlg/dlgwrap.c",
    "src/gzip/ftgzip.c",
    "src/bzip2/ftbzip2.c",
    "src/lzw/ftlzw.c",
    "src/pcf/pcf.c",
    "src/pfr/pfr.c",
    "src/psaux/psaux.c",
    "src/pshinter/pshinter.c",
    "src/psnames/psmodule.c",
    "src/raster/raster.c",
    "src/sfnt/sfnt.c",
    "src/smooth/smooth.c",
    "src/sdf/sdf.c",
    "src/svg/svg.c",
    "src/truetype/truetype.c",
    "src/type1/type1.c",
    "src/type42/type42.c",
    "src/winfonts/winfnt.c",
}

if is_plat("windows", "mingw") then
    table.join2(freetypeFiles, {
        "builds/windows/ftdebug.c",
        "builds/windows/ftsystem.c",
        "src/base/ftver.rc",
    })
elseif is_plat("macosx") then
    table.join2(freetypeFiles, {
        "src/base/ftdebug.c",
        "builds/mac/ftmac.c",
        "builds/unix/ftsystem.c",
    })
elseif is_plat("linux", "android", "iphoneos", "wasm") then
    table.join2(freetypeFiles, {
        "src/base/ftdebug.c",
        "builds/unix/ftsystem.c",
    })
else
    table.join2(freetypeFiles, {
        "src/base/ftdebug.c",
        "builds/base/ftsystem.c",
    })
end

local options = {
    "zlib",
    "bzip2",
    "brotli",
    "png",
    "harfbuzz"
}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op)
    end
end

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("freetype")
    set_kind("$(kind)")
    add_includedirs(
        "include",
        "src/base"
    )
    check_cincludes("HAVE_FCNTL_H", "fcntl.h")
    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_defines(
        "FT2_BUILD_LIBRARY"
    )
    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
            if op ~= "zlib" then
                add_defines(
                    "FT_CONFIG_OPTION_USE_"..string.upper(op)
                )
            else
                add_defines("FT_CONFIG_OPTION_USE_ZLIB", "FT_CONFIG_OPTION_SYSTEM_ZLIB")
            end
        end
    end
    if is_kind("shared") then
        add_defines("DLL_EXPORT")
    end
    if is_plat("windows", "mingw") then
        add_defines(
            "_CRT_SECURE_NO_WARNINGS",
            "_CRT_NONSTDC_NO_WARNINGS"
        )
    end
    for _, f in ipairs(freetypeFiles) do
        add_files(f)
    end
