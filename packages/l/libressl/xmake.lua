package("libressl")
    set_homepage("https://www.libressl.org")
    set_description("LibreSSL is a version of the TLS/crypto stack forked from OpenSSL in 2014, with goals of modernizing the codebase, improving security, and applying best practice development processes.")
    set_license("MIT")
    set_urls("https://github.com/PowerShell/LibreSSL/archive/refs/tags/V$(version).0.tar.gz")

    add_versions("3.8.2", "fe4019a388804f7e08135ffb115d5feaca94844f4ef4d7e3dbf36c4fe338ceb5")
    add_configs("asm", {description = "use asm", default = true, type = "boolean"})
    add_configs("openssldir", {description = "openssldir set", default = nil, type = "string"})
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt")
    elseif is_plat("linux") then
        add_syslinks("pthread")
    end
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {}
        table.insert(configs, "--asm="..(package:config("asm") and 'y' or 'n'))
        if package:config('openssldir') then
            table.insert(configs, "--openssldir="..package:config('openssldir'))
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("tls_init", {includes = {"tls.h"}}))
        assert(package:has_cfuncs("SSL_CTX_new", {includes = {"openssl/ssl.h"}, links = {"ssl"}}))
    end)
