package("libressl")
    set_homepage("https://www.libressl.org")
    set_description("LibreSSL is a version of the TLS/crypto stack forked from OpenSSL in 2014, with goals of modernizing the codebase, improving security, and applying best practice development processes.")
    set_license("MIT")

    add_urls("https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$(version).tar.gz")

    --insert version
    add_versions("4.1.0", "0f71c16bd34bdaaccdcb96a5d94a4921bfb612ec6e0eba7a80d8854eefd8bb61")
    add_versions("4.0.0", "4d841955f0acc3dfc71d0e3dd35f283af461222350e26843fea9731c0246a1e4")
    add_versions("3.9.2", "7b031dac64a59eb6ee3304f7ffb75dad33ab8c9d279c847f92c89fb846068f97")

    add_patches("4.0.0", path.join(os.scriptdir(), "patches/001-ios-add-byte-order-macros.patch"), "4682df68e68be07ca3b1e362ac2035cf293ac786df9f99fc866522564d7b957f")

    add_configs("asm", {description = "use asm", default = true, type = "boolean"})
    add_configs("openssldir", {description = "openssldir set", default = nil, type = "string"})
    add_configs("ca", {description = "default ca file path", default = nil, type = "string"})
    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt")
    elseif is_plat("linux") then
        add_syslinks("pthread")
    end
    add_links("tls", "ssl", "crypto")
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
        if package:config('ca') then
            table.insert(configs, "--ca="..package:config('ca'))
        end
        if package:version():ge("4.0.0") then
            table.insert(configs, "--file_version="..tostring(package:version()))
        end
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("tls_init", {includes = {"tls.h"}}))
        assert(package:has_cfuncs("SSL_CTX_new", {includes = {"openssl/ssl.h"}}))
    end)
