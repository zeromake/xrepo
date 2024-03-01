package("zstd")
    set_homepage("https://facebook.github.io/zstd")
    set_description("Zstandard - Fast real-time compression algorithm")
    set_license("BSD-2-Clause")
    set_urls("https://github.com/facebook/zstd/releases/download/v$(version)/zstd-$(version).tar.gz")

    add_versions("1.5.5", "9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4")
    add_versions("1.5.2", "7c42d56fac126929a6a85dbc73ff1db2411d04f104fae9bdea51305663a83fd0")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ZSTD_versionNumber", {includes = {"zstd.h"}}))
    end)
