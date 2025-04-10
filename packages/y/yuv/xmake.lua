local function getVersion(version)
    local versions ={
        ["2024.10.29-alpha"] = "archive/237f39cb8c6e6ea05b793d33416bfa168a02aec6.tar.gz",
        ["2024.11.01-alpha"] = "archive/b0f72309c6c0b952d0198be5a5b5106f089fe1c5.tar.gz",
        ["2024.11.15-alpha"] = "archive/75f7cfdde55155112d6c4d59b92aef1735eedb24.tar.gz",
        ["2024.11.25-alpha"] = "archive/9a9752134e251b8ac5980cf847ba141e408da138.tar.gz",
        ["2024.12.03-alpha"] = "archive/9144583f22ba23900e89c03c8483d2f42c712f6c.tar.gz",
        ["2024.12.19-alpha"] = "archive/533dc5866b4c167c19d2e243ef26e1eda4966313.tar.gz",
        ["2025.01.03-alpha"] = "archive/cacaf42e97284107dc88502c8f0af9ac356d199b.tar.gz",
        ["2025.01.09-alpha"] = "archive/e2c92b560ca76d640bef04715c3c26939e8ca519.tar.gz",
        ["2025.02.11-alpha"] = "archive/61354d2671d9b5c73cc964415fe25bc76cea051a.tar.gz",
        ["2025.02.27-alpha"] = "archive/c060118bea3f28ceb837d3c85e479d3bb4c21726.tar.gz",
        ["2025.03.14-alpha"] = "archive/4ed75166cf1885b9690214b362f8675294505a37.tar.gz",
        ["2025.04.04-alpha"] = "archive/8c48036d15d66ae951edbbeccfd3d0f268d589b9.tar.gz",
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
    add_versions("2025.04.04-alpha", "f8f7875f52e45d89c0ba6d37e0cfe905297d3f10fcc7974a9e7268fe87f277be")
    add_versions("2025.03.14-alpha", "4c0ddeb671e66b188aabbebbf56c40735cd3f7a793aff040d4e809d0c81eaf2f")
    add_versions("2025.02.27-alpha", "b509e836fde118b70f5f65b0c6835c724b37b63d4a5d52c2b49f76944645e948")
    add_versions("2025.02.11-alpha", "f44d790826facb7f1879e4691b5daf2415a95039f12fd3b66122b2a0bc018276")
    add_versions("2025.01.09-alpha", "a7cae8fd7daf7e7d34e912b12ae90a73fdb9a7666cd5635be82a958c18dffdda")
    add_versions("2025.01.03-alpha", "552937157eac901c0347ad72fc8725b2cfb9abbdf3aa87bac396210e5ff88e3b")
    add_versions("2024.12.19-alpha", "979c2141f0f0e9131da3500985d2d27f3bed8abcfcba1061806d6768e145155f")
    add_versions("2024.12.03-alpha", "9ae3fd7d5817f45f405a45153ed615acf6030830797aeddc0ebf40ae80d6f8c6")
    add_versions("2024.11.25-alpha", "25e48eb78c41383e391b68ed017e82e42ded0ae2667fb399f7b2442582ae2af2")
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
