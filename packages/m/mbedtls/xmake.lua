package("mbedtls")
    set_homepage("https://www.trustedfirmware.org/projects/mbed-tls/")
    set_description("An open source, portable, easy to use, readable and flexible TLS library, and reference implementation of the PSA Cryptography API.")
    set_license("Apache-2.0")
    set_urls("https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-$(version)/mbedtls-$(version).tar.bz2")

    --insert version
    add_versions("3.6.4", "ec35b18a6c593cf98c3e30db8b98ff93e8940a8c4e690e66b41dfc011d678110")
    add_versions("3.6.3", "64cd73842cdc05e101172f7b437c65e7312e476206e1dbfd644433d11bc56327")
    add_versions("3.6.2", "8b54fb9bcf4d5a7078028e0520acddefb7900b3e66fec7f7175bb5b7d85ccdca")
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
