package("quictls")
    set_homepage("https://quictls.github.io/openssl")
    set_description("TLS/SSL and crypto library with QUIC APIs")
    set_license("Apache-2.0")
    set_urls("https://github.com/quictls/openssl/archive/refs/tags/openssl-$(version).tar.gz")

    --insert version
    add_versions("3.3.0-quic1", "78d675d94c0ac3a8b44073f0c2b373d948c5afd12b25c9e245262f563307a566")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
