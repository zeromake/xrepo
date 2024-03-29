local function getVersion(version)
    local versions ={
        ["2022.06.29-alpha"] = "archive/6900494d90ae095d44405cd4cc3f346971fa69c9.tar.gz",
        ["2024.02.29-alpha"] = "archive/b66c42d4a8fbf56d2c83aa3ea55761b9fef363f5.tar.gz",
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

    add_versions("2024.02.29-alpha", "3e59a182c7be9245d786f60e5868f6bb061d031f73c3b795f65cef32896d357a")
    add_versions("2022.06.29-alpha", "204bf84d9f86b427130c9adbeb499e02e6aed056a5b9b5d485abd71eb35ffb44")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
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
