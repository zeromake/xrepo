package("libressl")
    set_homepage("https://www.libressl.org")
    set_description("LibreSSL is a version of the TLS/crypto stack forked from OpenSSL in 2014, with goals of modernizing the codebase, improving security, and applying best practice development processes.")
    set_license("MIT")

    add_urls("https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$(version).tar.gz")

    add_versions("3.9.2", "7b031dac64a59eb6ee3304f7ffb75dad33ab8c9d279c847f92c89fb846068f97")
    add_versions("3.8.2", "6d4b8d5bbb25a1f8336639e56ec5088052d43a95256697a85c4ce91323c25954")
    add_configs("asm", {description = "use asm", default = true, type = "boolean"})
    add_configs("openssldir", {description = "openssldir set", default = nil, type = "string"})
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt")
    elseif is_plat("linux") then
        add_syslinks("pthread")
    end
    on_install(function (package)
        local export_prefix = package:version():ge("3.9.0") and "libressl_" or ""
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {
            "--export_prefix="..export_prefix,
        }
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
