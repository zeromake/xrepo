local function getVersion(version)
    local versions ={
        ["2024.10.29-alpha"] = "archive/237f39cb8c6e6ea05b793d33416bfa168a02aec6.tar.gz",
        ["2024.11.01-alpha"] = "archive/b0f72309c6c0b952d0198be5a5b5106f089fe1c5.tar.gz",
        ["2024.11.15-alpha"] = "archive/75f7cfdde55155112d6c4d59b92aef1735eedb24.tar.gz",
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
    add_versions("2024.11.15-alpha", "c7290350398860fdb80e3840e0f907a64c51dbb4bdff59eec505f473723a4bbd")
    add_versions("2024.11.01-alpha", "210f148a56244c265e457a0f3cd56cbb63bfe3cd55587ff68884f10ab5a4aaed")
    add_versions("2024.10.29-alpha", "a61cff4a691edf4d6fcb8a2d3b13b23609f20522a43e8f7e2b836ee28ccccd1a")
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
