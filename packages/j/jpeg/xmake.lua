package("jpeg")
    set_homepage("https://www.ijg.org")
    set_description("A widely used C library for reading and writing JPEG image files.")

    set_license("bsd")
    set_urls("http://www.ijg.org/files/jpegsrc.v$(version).tar.gz")
    add_versions("9e", "4077d6a6a75aeb01884f708919d25934c93305e49f7e3f36db9129320e6f4f3d")

    add_includedirs("include")
    on_install("windows", "mingw", "macosx", "linux", function (package)
        io.writefile("xmake.lua", [[
            includes("check_cincludes.lua")
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
        ]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("jpeg_create_compress(0)", {includes = {"stdio.h", "jpeglib.h"}}))
    end)
