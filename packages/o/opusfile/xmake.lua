package("opusfile")
    set_homepage("https://github.com/xiph/opusfile")
    set_description("Stand-alone decoder library for .opus streams")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/xiph/opusfile/releases/download/v$(version)/opusfile-$(version).tar.gz")

    add_versions("0.12", "118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b")
    add_deps("ogg", "opus")
    on_install(function (package)
        local text = io.readfile("include/opusfile.h"):gsub("# ?include <opus_multistream%.h>", "# include <opus/opus_multistream.h>")
        io.writefile("include/opusfile.h", text, {encoding = "binary"})
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
