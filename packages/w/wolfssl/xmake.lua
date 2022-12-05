local options = {}

package("wolfssl")
    set_homepage("https://www.wolfssl.com")
    set_description("The wolfSSL library is a small, fast, portable implementation of TLS/SSL for embedded devices to the cloud. wolfSSL supports up to TLS 1.3!")
    set_license("GPLv2")
    set_urls("https://github.com/wolfSSL/wolfssl/archive/refs/tags/v$(version)-stable.tar.gz")
    
    add_versions("5.5.0", "c34b74b5f689fac7becb05583b044e84d3b10d39f38709f0095dd5d423ded67f")

    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include", "include/wolfssl")

    add_defines(
        "WOLFSSL_DES_ECB",
        "WOLFSSL_LIB",
        "WOLFSSL_USER_SETTINGS",
        "CYASSL_USER_SETTINGS",
        "WOLFSSL_NO_MD4",
        "OPENSSL_EXTRA",
        "WOLFSSL_SHA512"
    )

    if is_plat("windows", "mingw") then
        add_syslinks("advapi32", "ws2_32")
    end

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp("wolfssl/options.h.in", "wolfssl/options.h")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
        os.cp("wolfssl", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("wolfSSL_GetVersion(NULL)", {includes = {"wolfssl/options.h", "wolfssl/ssl.h"}}))
    end)
