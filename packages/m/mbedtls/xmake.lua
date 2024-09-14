package("mbedtls")
    set_homepage("https://www.trustedfirmware.org/projects/mbed-tls/")
    set_description("An open source, portable, easy to use, readable and flexible TLS library, and reference implementation of the PSA Cryptography API.")
    set_license("Apache-2.0")
    set_urls("https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v$(version).tar.gz")

    add_versions("3.6.1", "db75d2f7f35e29cf09f7bd6734d8ee3325f29c298ef071350c5e70a40dd4f0f9")
    add_versions("3.6.0", "32c500e73ee878e193e7d66bf5e4c34fb42bb968a6c9f9488aa466b16f6f3bff")
    add_versions("3.5.2", "35890edf1a2c7a7e29eac3118d43302c3e1173e0df0ebaf5db56126dabe5bb05")
    on_load(function (package) 
        if package:is_plat("windows", "mingw") then
            package:add("syslinks", "bcrypt")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("mbedtls_ssl_init", {includes = "mbedtls/ssl.h"}))
    end)
