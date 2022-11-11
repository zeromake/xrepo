package("zlib")
    set_homepage("https://www.zlib.net")
    set_description("A Massively Spiffy Yet Delicately Unobtrusive Compression Library")
    set_license("zlib")
    set_urls("https://github.com/madler/zlib/releases/download/v$(version)/zlib-$(version).tar.gz")

    add_versions("1.2.13", "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30")

    add_includedirs("include")
    on_install("windows", "mingw", "macosx", "linux", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("gzopen(NULL, NULL)", {includes = "zlib.h"}))
    end)
