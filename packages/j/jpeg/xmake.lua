local function getVersion(version)
    local versions ={
        ["2022.05.07"] = "archive/1cd244dca8451b0f5f18f04c8eaa4bfe3f866c49.tar.gz",
    }
    return versions[tostring(version)]
end

package("jpeg")
    set_homepage("https://www.ijg.org")
    set_description("A widely used C library for reading and writing JPEG image files.")

    set_license("BSD-2-Clause")
    set_urls("https://github.com/libsdl-org/jpeg/$(version)", {
        version = getVersion
    })
    add_versions("2022.05.07", "149dc39fc0e37bab3996430c581bdb525e3664e380ffcd57b05addafa8e2800d")

    add_includedirs("include")
    on_install(function (package)
        io.writefile("jconfig.txt", [[
#define HAVE_PROTOTYPES 1
#define HAVE_UNSIGNED_CHAR 1
#define HAVE_UNSIGNED_SHORT 1
#define HAVE_STDDEF_H 1
#define HAVE_STDLIB_H 1
#define HAVE_LOCALE_H 1
#ifdef JPEG_INTERNALS
#define INLINE __inline__
#endif
#ifdef JPEG_CJPEG_DJPEG
#define BMP_SUPPORTED
#define GIF_SUPPORTED
#define PPM_SUPPORTED
#define TARGA_SUPPORTED
#endif]], {encoding = "binary"})      
        io.writefile("xmake.lua", [[
if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")
target("jpeg")
    set_kind("$(kind)")
    if is_plat("windows", "mingw") then
        add_configfiles("jconfig.vc", {filename = "jconfig.h"})
    else
        add_configfiles("jconfig.txt", {filename = "jconfig.h"})
    end
    add_includedirs("$(buildir)", {public = true})
    add_headerfiles(
        "$(buildir)/jconfig.h",
        "jpeglib.h",
        "jmorecfg.h",
        "jpegint.h",
        "jerror.h"
    )
    for _, f in ipairs({
        "jaricom.c",
        "jcapimin.c",
        "jcapistd.c",
        "jcarith.c",
        "jccoefct.c",
        "jccolor.c",
        "jcdctmgr.c",
        "jchuff.c",
        "jcinit.c",
        "jcmainct.c",
        "jcmarker.c",
        "jcmaster.c",
        "jcomapi.c",
        "jcparam.c",
        "jcprepct.c",
        "jcsample.c",
        "jctrans.c",
        "jdapimin.c",
        "jdapistd.c",
        "jdarith.c",
        "jdatadst.c",
        "jdatasrc.c",
        "jdcoefct.c",
        "jdcolor.c",
        "jddctmgr.c",
        "jdhuff.c",
        "jdinput.c",
        "jdmainct.c",
        "jdmarker.c",
        "jdmaster.c",
        "jdmerge.c",
        "jdpostct.c",
        "jdsample.c",
        "jdtrans.c",
        "jerror.c",
        "jfdctflt.c",
        "jfdctfst.c",
        "jfdctint.c",
        "jidctflt.c",
        "jidctfst.c",
        "jidctint.c",
        "jquant1.c",
        "jquant2.c",
        "jutils.c",
        "jmemmgr.c",
        "jmemansi.c",
    }) do
        add_files(f)
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("jpeg_create_compress(0)", {includes = {"stdio.h", "jpeglib.h"}}))
    end)
