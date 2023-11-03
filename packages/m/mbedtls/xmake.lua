package("mbedtls")
    set_homepage("https://www.trustedfirmware.org/projects/mbed-tls/")
    set_description("An open source, portable, easy to use, readable and flexible TLS library, and reference implementation of the PSA Cryptography API.")
    set_license("Apache-2.0")
    set_urls("https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-$(version).tar.gz")

    add_versions("3.5.0", "02311fc8bd032d89ff9aee535dddb55458108dc0d4c5280638fc611aea7c5e4a")
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
