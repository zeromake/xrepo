package("mbedtls")
    set_homepage("https://www.trustedfirmware.org/projects/mbed-tls/")
    set_description("An open source, portable, easy to use, readable and flexible TLS library, and reference implementation of the PSA Cryptography API.")
    set_license("Apache-2.0")
    set_urls("https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-$(version)/mbedtls-$(version).tar.bz2")

    --insert version
    add_versions("3.6.1", "fc8bef0991b43629b7e5319de6f34f13359011105e08e3e16eed3a9fe6ffd3a3")
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
