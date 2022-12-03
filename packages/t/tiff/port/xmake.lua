includes("check_cincludes.lua")
includes("check_csnippets.lua")
includes("check_cfuncs.lua")
includes("check_ctypes.lua")
add_rules("mode.debug", "mode.release")

local options = {}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op)
    end
end

add_requires("zlib", "jpeg")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

function configvar_check_bigendian(define_name) 
    configvar_check_csnippets(define_name, [[
union{long int l;char c[sizeof (long int)];} u;
u.l = 1;
int result = u.c[sizeof(long int)-1];
printf("%d", result);
return 0;
]], {output = true, number = true})
end

function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

local sourceFiles = {
    "tif_aux.c",
    "tif_close.c",
    "tif_codec.c",
    "tif_color.c",
    "tif_compress.c",
    "tif_dir.c",
    "tif_dirinfo.c",
    "tif_dirread.c",
    "tif_dirwrite.c",
    "tif_dumpmode.c",
    "tif_error.c",
    "tif_extension.c",
    "tif_fax3.c",
    "tif_fax3sm.c",
    "tif_flush.c",
    "tif_getimage.c",
    "tif_jbig.c",
    "tif_jpeg.c",
    "tif_jpeg_12.c",
    "tif_lerc.c",
    "tif_luv.c",
    "tif_lzma.c",
    "tif_lzw.c",
    "tif_next.c",
    "tif_ojpeg.c",
    "tif_open.c",
    "tif_packbits.c",
    "tif_pixarlog.c",
    "tif_predict.c",
    "tif_print.c",
    "tif_read.c",
    "tif_strip.c",
    "tif_swab.c",
    "tif_thunder.c",
    "tif_tile.c",
    "tif_version.c",
    "tif_warning.c",
    "tif_webp.c",
    "tif_write.c",
    "tif_zip.c",
    "tif_zstd.c",
}

target("tiff")
    set_kind("$(kind)")

    add_headerfiles(
        "libtiff/tiff.h",
        "libtiff/tiffio.h",
        "libtiff/tiffvers.h"
    )

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("tiffconf.h.in", "tif_config.h.in")
    add_headerfiles("$(buildir)/config/tiffconf.h")

    configvar_check_ctypes("HAVE_DECL_OPTARG", "optarg", {includes={"unistd.h"}})
    configvar_check_ctypes("HAVE_FSEEKO", "fseeko", {includes={"stdio.h"}})

    configvar_check_cfuncs("HAVE_GETOPT", "getopt", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_JBG_NEWLEN", "jbg_newlen", {includes={"jbig.h"}})
    configvar_check_cfuncs("HAVE_MMAP", "mmap", {includes={"sys/mman.h"}})
    configvar_check_cfuncs("HAVE_SETMODE", "setmode", {includes={"io.h"}})

    configvar_check_cincludes("HAVE_GLUT_GLUT_H", "GLUT/glut.h")
    configvar_check_cincludes("HAVE_GL_GLUT_H", "GL/glut.h")
    configvar_check_cincludes("HAVE_GL_GLU_H", "GL/glu.h")
    configvar_check_cincludes("HAVE_GL_GL_H", "GL/gl.h")
    configvar_check_cincludes("HAVE_OPENGL_GLU_H", "OpenGL/glu.h")
    configvar_check_cincludes("HAVE_OPENGL_GL_H", "OpenGL/gl.h")
    configvar_check_cincludes("HAVE_ASSERT_H", "assert.h")
    configvar_check_cincludes("HAVE_IO_H", "io.h")
    configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
    configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")

    set_configvar("CHECK_JPEG_YCBCR_SUBSAMPLING", 1)
    set_configvar("CXX_SUPPORT", 1)

    configvar_check_bigendian("HOST_BIGENDIAN")

    configvar_check_sizeof("SIZEOF_SIZE_T", "size_t")

    set_configvar("HAVE_IEEEFP", 1)
    set_configvar("CCITT_SUPPORT", 1)
    set_configvar("JPEG_SUPPORT", 1)
    set_configvar("LOGLUV_SUPPORT", 1)
    set_configvar("NEXT_SUPPORT", 1)
    set_configvar("OJPEG_SUPPORT", 1)
    set_configvar("PACKBITS_SUPPORT", 1)
    set_configvar("PIXARLOG_SUPPORT", 1)
    set_configvar("THUNDER_SUPPORT", 1)
    set_configvar("ZIP_SUPPORT", 1)
    set_configvar("SUBIFD_SUPPORT", 1)
    set_configvar("DEFAULT_EXTRASAMPLE_AS_ALPHA", 1)
    set_configvar("MDI_SUPPORT", 1)

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
        end
    end

    add_packages("zlib", "jpeg")

    for _, f in ipairs(sourceFiles) do
        add_files(path.join("libtiff", f))
    end

    if is_plat("windows", "mingw") then
        add_defines("USE_WIN32_FILEIO=1", "HAVE_IO_H=1")
        add_files("libtiff/tif_win32.c")
    else
        add_files("libtiff/tif_unix.c")
    end
