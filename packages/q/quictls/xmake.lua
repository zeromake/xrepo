package("quictls")
    set_homepage("https://quictls.github.io/openssl")
    set_description("TLS/SSL and crypto library with QUIC APIs")
    set_license("Apache-2.0")
    set_urls("https://github.com/quictls/openssl/archive/refs/tags/openssl-$(version).tar.gz")

    --insert version
    add_versions("3.3.0-quic1", "78d675d94c0ac3a8b44073f0c2b373d948c5afd12b25c9e245262f563307a566")
    add_configs("installdir", {description = "installdir set", default = nil, type = "string"})
    add_links("ssl", "crypto")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "generate_xmake.lua"), "xmake.lua")
        os.cp(path.join(os.scriptdir(), "port", "scripts"), "scripts")
        local configs = {}
        if package:config('installdir') then
            table.insert(configs, "--installdir="..package:config('installdir'))
        end
        import("package.tools.xmake").install(package, configs)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("SSL_CTX_new", {includes = {"openssl/ssl.h"}}))
    end)
