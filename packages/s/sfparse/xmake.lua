local function getVersion(version)
    local versions ={
        ["2024.10.01-alpha"] = "archive/34aca68a80e39d52a081380e360a7b48e936ad22.tar.gz",
        ["2024.10.04-alpha"] = "archive/f1dd8a9bb40b7c14c4064078c4433397a3e0abcd.tar.gz",
        ["2024.10.18-alpha"] = "archive/93fd4cd5268ad1adc8e3c8ff2002b772b1a8b983.tar.gz",
        ["2024.11.13-alpha"] = "archive/7eaf5b651f67123edf2605391023ed2fd7e2ef16.tar.gz",
        ["2024.12.15-alpha"] = "archive/930bdf8421f29cf0109f0f1baaafffa376973ed5.tar.gz",
        ["2025.01.03-alpha"] = "archive/e8266e3f2a5ad2edd1165e0b70ec422239951837.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("sfparse")
    set_homepage("https://nghttp2.org/sfparse")
    set_description("Structured Field Values parser")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/sfparse/$(version)", {version = getVersion})

    --insert version
    add_versions("2025.01.03-alpha", "f1d3c8ff89b88cd432b362fedfbddd736b921668091b2df839311ad7cd9b2618")
    add_versions("2024.12.15-alpha", "6025bda9b3b00df3091fad9967ef04fc48647b62033773f458d88434d26cd1ec")
    add_versions("2024.11.13-alpha", "ca641a06df389d4c316f1cd915ebb6212579c48473c3f7b183cc6547ce4d2970")
    add_versions("2024.10.18-alpha", "e980eb4ba193ee24208da8f13ee676312f43ef32e5e4be77020d1e1619b54310")
    add_versions("2024.10.04-alpha", "26778bbfb310db00a539258097ea7230b3efa0ad0a2671d7c3314db9d988bde1")
    add_versions("2024.10.01-alpha", "a82fc1307d1a6dc9e6fab920ce47eed7f5f03ad33c2439e60f6a1ad8f3617fb5")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
target("sfparse")
    set_kind("$(kind)")
    add_files("sfparse.c")
    add_headerfiles("sfparse.h")
]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
