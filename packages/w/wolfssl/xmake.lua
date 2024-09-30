local options = {}

package("wolfssl")
    set_homepage("https://www.wolfssl.com")
    set_description("The wolfSSL library is a small, fast, portable implementation of TLS/SSL for embedded devices to the cloud. wolfSSL supports up to TLS 1.3!")
    set_license("GPLv2")
    set_urls("https://github.com/wolfSSL/wolfssl/archive/refs/tags/v$(version)-stable.tar.gz")

    --insert version
    add_versions("5.7.2", "0f2ed82e345b833242705bbc4b08a2a2037a33f7bf9c610efae6464f6b10e305")
    add_versions("5.7.0", "2de93e8af588ee856fe67a6d7fce23fc1b226b74d710b0e3946bc8061f6aa18f")
    add_versions("5.6.6", "3d2ca672d41c2c2fa667885a80d6fa03c3e91f0f4f72f87aef2bc947e8c87237")
    add_versions("5.6.4", "031691906794ff45e1e792561cf31759f5d29ac74936bc8dffb8b14f16d820b4")
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
        "WOLFSSL_NO_MD4"
    )

    if is_plat("windows", "mingw") then
        add_syslinks("advapi32", "ws2_32")
    elseif is_plat("macosx") then
        add_frameworks("CoreFoundation", "Security")
    end

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        os.cp("wolfssl/options.h.in", "wolfssl/options.h")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
        os.cp("wolfssl", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("wolfSSL_GetVersion(NULL)", {includes = {"wolfssl/options.h", "wolfssl/ssl.h"}}))
    end)
