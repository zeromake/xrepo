local function getVersion(version)
    local versions ={
        ["2024.06.18-alpha"] = "archive/efd164d64ee4aab463e00f69e0de7f53ca91865d.tar.gz",
        ["2024.07.02-alpha"] = "archive/611806a1559b92c97961f51c78805d8d9d528c08.tar.gz",
        ["2024.07.11-alpha"] = "archive/ec9a8781c7d63cd3d3b5442d88fb5f5271c4cefe.tar.gz",
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
