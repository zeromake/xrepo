local function getVersion(version)
    local versions ={
        ["2024.06.18-alpha"] = "archive/efd164d64ee4aab463e00f69e0de7f53ca91865d.tar.gz",
        ["2024.07.02-alpha"] = "archive/611806a1559b92c97961f51c78805d8d9d528c08.tar.gz",
        ["2024.07.11-alpha"] = "archive/ec9a8781c7d63cd3d3b5442d88fb5f5271c4cefe.tar.gz",
        ["2024.09.13-alpha"] = "archive/4620f1705822fd6ab99939f43ce63099bd3d9ae0.tar.gz",
        ["2024.09.27-alpha"] = "archive/77f3acade492a41a11a07a55b58a6f8180b898eb.tar.gz",
        ["2024.10.04-alpha"] = "archive/dfa279fc653622c2ce26550124dcca383a14d124.tar.gz",
        ["2024.10.09-alpha"] = "archive/a8e59d207483f75b87dd5fc670e937672cdf5776.tar.gz",
        ["2024.10.15-alpha"] = "archive/6ac7c8f25170c85265fca69fd1fe5d31baf3344f.tar.gz",
        ["2024.10.29-alpha"] = "archive/237f39cb8c6e6ea05b793d33416bfa168a02aec6.tar.gz",
        ["2024.11.01-alpha"] = "archive/b0f72309c6c0b952d0198be5a5b5106f089fe1c5.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("yuv")
    set_homepage("https://chromium.googlesource.com/libyuv/libyuv")
    set_description("libyuv is an open source project that includes YUV scaling and conversion functionality.")
    set_license("BSD-3-Clause")
    set_urls("https://github.com/lemenkov/libyuv/$(version)",
        {
            version = getVersion
        }
    )
    --insert version
    add_versions("2024.11.01-alpha", "210f148a56244c265e457a0f3cd56cbb63bfe3cd55587ff68884f10ab5a4aaed")
    add_versions("2024.10.29-alpha", "a61cff4a691edf4d6fcb8a2d3b13b23609f20522a43e8f7e2b836ee28ccccd1a")
    add_versions("2024.10.15-alpha", "cb18c91dae66cc68d9745181bf4f12106c4ab27c642c3b7bc3deee33086090d2")
    add_versions("2024.10.09-alpha", "41c1d8748fcd6c8c18636ad0d4b2c57d8bb830f8dda03a2ca7c0a64de02e5348")
    add_versions("2024.10.04-alpha", "cf7ae88ccb33187e6cbc81199d9b73b143e853e3355e2d5cf4b71e2abf0a52d8")
    add_versions("2024.09.27-alpha", "6c898607e2ec3a38cd88f210bd6eb17f0be9e89274d9b5b1e5a83ed29219d3a8")
    add_versions("2024.09.13-alpha", "fe0d1d41829fcf2b8057c70940c1ca8220c65316d7e0b681afe37759732ce3ec")
    add_versions("2024.07.11-alpha", "d7f803efbc63cc6f12456b420e7b01924103031c4541b269713325dfecb7f168")
    add_versions("2024.07.02-alpha", "a8dddc6f45d6987cd3c08e00824792f3c72651fde29f475f572ee2292c03761f")
    add_versions("2024.06.18-alpha", "61581bd62f0269a67ee4305f2ac3c69dd2488b9a9eb40558fae8e41f12f616f7")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end

target("yuv")
    set_kind("$(kind)")
    add_includedirs("include")
    add_files("source/*.cc")
    add_headerfiles("include/*.h")
    add_headerfiles("include/libyuv/*.h", {prefixdir = "libyuv"})
    if is_kind("shared") then
        add_defines("LIBYUV_BUILDING_SHARED_LIBRARY")
    end
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ScalePlane", {includes = {"libyuv.h"}}))
    end)
