package("curl")
    set_homepage("https://curl.se")
    set_description("A library for transferring data with URL syntax, supporting DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP. libcurl offers a myriad of powerful features")
    set_license("MIT")
    set_urls("https://github.com/curl/curl/releases/download/curl-$(version).tar.bz2", {version = function (version)
        return version:gsub("%.", "_") .. "/curl-" .. version
    end})

    --insert version
    add_versions("8.16.0", "9459180ab4933b30d0778ddd71c91fe2911fab731c46e59b3f4c8385b1596c91")
    add_versions("8.15.0", "699a6d2192322792c88088576cff5fe188452e6ea71e82ca74409f07ecc62563")
    add_versions("8.13.0", "e0d20499260760f9865cb6308928223f4e5128910310c025112f592a168e1473")
    add_versions("8.12.1", "18681d84e2791183e0e5e4650ccb2a080c1f3a4e57ed2fbc2457228579d68269")
    add_versions("8.12.0", "5a85adbe401ed3b998ee1128524e9b045feb39577f3c336f6997e7a4afaafcd7")
    add_versions("8.11.1", "e9773ad1dfa21aedbfe8e1ef24c9478fa780b1b3d4f763c98dd04629b5e43485")
    add_versions("8.11.0", "c95d5a1368803729345a632ce42cceeefd5f09c3b4d9582f858f6779f4b8b254")
    add_versions("8.10.1", "3763cd97aae41dcf41950d23e87ae23b2edb2ce3a5b0cf678af058c391b6ae31")
    add_versions("8.10.0", "be30a51f7bbe8819adf5a8e8cc6991393ede31f782b8de7b46235cc1eb7beb9f")
    add_versions("8.8.0", "40d3792d38cfa244d8f692974a567e9a5f3387c547579f1124e95ea2a1020d0d")
    add_versions("8.7.1", "05bbd2b698e9cfbab477c33aa5e99b4975501835a41b7ca6ca71de03d8849e76")
    add_versions("8.6.0", "b4785f2d8877fa92c0e45d7155cf8cc6750dbda961f4b1a45bcbec990cf2fa9b")
    add_versions("8.4.0", "e5250581a9c032b1b6ed3cf2f9c114c811fc41881069e9892d115cc73f9e88c6")
    add_versions("7.86.0", "f5ca69db03eea17fa8705bdfb1a9f58d76a46c9010518109bb38f313137e0a28")
    add_versions("7.85.0", "21a7e83628ee96164ac2b36ff6bf99d467c7b0b621c1f7e317d8f0d96011539c")

    add_configs("winrt", {description = "Support winrt", default = false, type = "boolean"})
    add_configs("wolfssl", {description = "use wolfssl", default = false, type = "boolean"})
    add_configs("libressl", {description = "use libressl", default = false, type = "boolean"})
    add_configs("brotli", {description = "use brotli", default = false, type = "boolean"})
    add_configs("zstd", {description = "use zstd", default = false, type = "boolean"})
    add_configs("ssh2", {description = "use ssh2", default = false, type = "boolean"})
    add_configs("ngtcp2", {description = "use ngtcp2", default = false, type = "boolean"})
    add_configs("nghttp2", {description = "use nghttp2", default = false, type = "boolean"})
    add_configs("nghttp3", {description = "use nghttp3", default = false, type = "boolean"})
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})

    add_deps("zlib")
    on_load(function (package)
        if package:is_plat("windows", "mingw") then
            package:add("syslinks", "ws2_32", "crypt32", "bcrypt", "advapi32", "normaliz", "secur32")
            if not package:config("winrt") then
                package:add("syslinks", "wldap32")
            end
        elseif package:is_plat("macosx", "iphoneos") then
            package:add("syslinks", "ldap", "icucore", "iconv")
            package:add("frameworks", "CoreFoundation", "Security", "SystemConfiguration")
        end
        if package:config("libressl") then
            package:add("deps", "libressl")
        elseif package:config("wolfssl") then
            package:add("deps", "wolfssl")
        end
        if package:config("brotli") then
            package:add("deps", "brotli")
        end
        if package:config("zstd") then
            package:add("deps", "zstd")
        end
        if package:config("ssh2") then
            package:add("deps", "ssh2")
        end
        if package:config("ngtcp2") then
            package:add("deps", "ngtcp2")
        end
        if package:config("nghttp2") then
            package:add("deps", "nghttp2")
        end
        if package:config("nghttp3") then
            package:add("deps", "nghttp3")
        end
        if package:config("shared") ~= true then
            package:add("defines", "BUILDING_LIBCURL", "CURL_STATICLIB")
        else
            package:add("defines", "BUILDING_LIBCURL")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        -- if is_plat("windows", "mingw") then
        --     os.cp("lib/config-win32.h", "lib/curl_config.h")
        -- end
        local transforme_configfile = function (input, output, extra)
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#undef ") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}\n"
                elseif line:startswith("#  undef ") then
                    local name = line:split("%s+")[3]
                    line = "${define "..name.."}\n"
                end
                out:write(line)
                out:write("\n")
            end
            if extra then
                out:write(extra)
            end
            out:close()
        end
        transforme_configfile("lib/curl_config.h.in", "curl_config.h.in", [[
${define HAVE_SA_FAMILY_T}

${define HAVE_SSIZE_T}
${define USE_WIN32_LARGE_FILES}

#ifndef HAVE_SSIZE_T
#ifdef HAVE_LONGLONG
#define ssize_t long long
#else
#define ssize_t size_t
#endif
#endif

#if defined(BUILDING_CURL_CLI) && defined(BUILDING_LIBCURL)
#define curlx_dynbuf dynbuf
#define curlx_dyn_init Curl_dyn_init
#define curlx_dyn_add Curl_dyn_add
#define curlx_dyn_addn Curl_dyn_addn
#define curlx_dyn_addf Curl_dyn_addf
#define curlx_dyn_vaddf Curl_dyn_vaddf
#define curlx_dyn_free Curl_dyn_free
#define curlx_dyn_ptr Curl_dyn_ptr
#define curlx_dyn_uptr Curl_dyn_uptr
#define curlx_dyn_len Curl_dyn_len
#define curlx_dyn_reset Curl_dyn_reset
#define curlx_dyn_tail Curl_dyn_tail
#define curlx_dyn_setlen Curl_dyn_setlen
#define curlx_base64_encode Curl_base64_encode
#define curlx_base64url_encode Curl_base64url_encode
#define curlx_base64_decode Curl_base64_decode
#endif
]])
        local configs = {}
        configs["wolfssl"] = package:config("wolfssl") and "y" or "n"
        configs["winrt"] = package:config("winrt") and "y" or "n"
        configs["libressl"] = package:config("libressl") and "y" or "n"
        configs["brotli"] = package:config("brotli") and "y" or "n"
        configs["zstd"] = package:config("zstd") and "y" or "n"
        configs["ssh2"] = package:config("ssh2") and "y" or "n"
        configs["ngtcp2"] = package:config("ngtcp2") and "y" or "n"
        configs["nghttp2"] = package:config("nghttp2") and "y" or "n"
        configs["nghttp3"] = package:config("nghttp3") and "y" or "n"
        configs["cli"] = package:config("cli") and "y" or "n"
        import("package.tools.xmake").install(package, configs)
        import("net.http")
        print("https://curl.se/ca/cacert.pem -> bin/curl-ca-bundle.crt")
        http.download("https://curl.se/ca/cacert.pem", path.join(package:installdir("bin"), "curl-ca-bundle.crt"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("curl_version()", {includes = {"curl/curl.h"}}))
    end)
