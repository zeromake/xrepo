local options = {}

package("tiff")
    set_homepage("https://libtiff.gitlab.io/libtiff")
    set_description("The LibTIFF software provides support for the Tag Image File Format (TIFF), a widely used format for storing image data.")
    set_license("MIT")
    set_urls("https://download.osgeo.org/libtiff/tiff-$(version).tar.xz")

    add_versions("4.4.0", "49307b510048ccc7bc40f2cba6e8439182fe6e654057c1a1683139bf2ecb1dc1")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)
    add_deps("zlib", "jpeg")
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        io.writefile("tiffconf.h.in", [[
#ifndef _TIFFCONF_
#define _TIFFCONF_

#include <stddef.h>
#include <stdint.h>
#include <inttypes.h>

#define TIFF_INT16_T int16_t
#define TIFF_INT32_T int32_t
#define TIFF_INT64_T int64_t
#define TIFF_INT8_T int8_t
#define TIFF_UINT16_T uint16_t
#define TIFF_UINT32_T uint32_t
#define TIFF_UINT64_T uint64_t
#define TIFF_UINT8_T uint8_t
#define TIFF_SSIZE_T int64_t

${define HOST_BIGENDIAN}

${define HAVE_IEEEFP}
${define CCITT_SUPPORT}
${define JPEG_SUPPORT}
${define LOGLUV_SUPPORT}
${define NEXT_SUPPORT}
${define OJPEG_SUPPORT}
${define PACKBITS_SUPPORT}
${define PIXARLOG_SUPPORT}
${define THUNDER_SUPPORT}
${define ZIP_SUPPORT}
${define SUBIFD_SUPPORT}
${define DEFAULT_EXTRASAMPLE_AS_ALPHA}
${define MDI_SUPPORT}


#ifdef HOST_BIGENDIAN
#define HOST_FILLORDER FILLORDER_MSB2LSB 
#else
#define HOST_FILLORDER FILLORDER_LSB2MSB
#endif

#define STRIPCHOP_DEFAULT TIFF_STRIPCHOP

#define COLORIMETRY_SUPPORT
#define YCBCR_SUPPORT
#define CMYK_SUPPORT
#define ICC_SUPPORT
#define PHOTOSHOP_SUPPORT
#define IPTC_SUPPORT

#endif /* _TIFFCONF_ */
]])

        io.writefile("tif_config.h.in", [[
#include "tiffconf.h"

${define CCITT_SUPPORT}
${define HAVE_DECL_OPTARG}
${define HAVE_FSEEKO}

${define HAVE_GETOPT}
${define HAVE_JBG_NEWLEN}
${define HAVE_MMAP}
${define HAVE_SETMODE}

${define HAVE_GLUT_GLUT_H}
${define HAVE_GL_GLUT_H}
${define HAVE_GL_GLU_H}
${define HAVE_GL_GL_H}
${define HAVE_OPENGL_GLU_H}
${define HAVE_OPENGL_GL_H}
${define HAVE_IO_H}
${define HAVE_STRINGS_H}
${define HAVE_SYS_TYPES_H}
${define HAVE_UNISTD_H}
${define HAVE_FCNTL_H}

${define CHECK_JPEG_YCBCR_SUBSAMPLING}
${define CXX_SUPPORT}
${define SIZEOF_SIZE_T}

// #undef WEBP_SUPPORT
// #undef ZSTD_SUPPORT

#define LIBJPEG_12_PATH ""

#define PACKAGE "LibTIFF Software"
#define PACKAGE_BUGREPORT "tiff@lists.maptools.org"
#define PACKAGE_NAME "LibTIFF Software"
#define PACKAGE_STRING "LibTIFF Software 4.4.0"
#define PACKAGE_TARNAME "tiff"
#define PACKAGE_URL ""
#define PACKAGE_VERSION "4.4.0"
#define STRIP_SIZE_DEFAULT 8192
#define VERSION "4.4.0"

#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
#  undef WORDS_BIGENDIAN
# endif
#endif

#if !defined(__MINGW32__)
#  define TIFF_SIZE_FORMAT "zu"
#endif
#if SIZEOF_SIZE_T == 8
#  define TIFF_SSIZE_FORMAT PRId64
#  if defined(__MINGW32__)
#    define TIFF_SIZE_FORMAT PRIu64
#  endif
#elif SIZEOF_SIZE_T == 4
#  define TIFF_SSIZE_FORMAT PRId32
#  if defined(__MINGW32__)
#    define TIFF_SIZE_FORMAT PRIu32
#  endif
#else
#  error "Unsupported size_t size; please submit a bug report"
#endif
]])
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("TIFFGetVersion()", {includes = {"tiffio.h"}}))
    end)
