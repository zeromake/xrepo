local function getVersion(version)
    local versions ={
        ["2024.02.12-alpha"] = "archive/d127078cedef9c6642cbe592dacdd2292b50bb19.tar.gz",
    }
    return versions[tostring(version)]
end
package("compact_enc_det")
    set_homepage("https://github.com/google/compact_enc_det")
    set_description("Compact Encoding Detection")
    set_license("Apache-2.0")
    set_urls("https://github.com/google/compact_enc_det/$(version)", {
        version = getVersion
    })

    add_versions("2024.02.12-alpha", "64ac9ec452931253e687939198fbd7236d764f3670bfcb61b3b7f6c40d5332e0")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")

add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})

target("compact_enc_det")
    set_kind("$(kind)")
    add_files(
        "compact_enc_det/*.cc|compact_enc_det_unittest.cc|compact_enc_det_fuzz_test.cc",
        "util/encodings/*.cc|encodings_unittest.cc",
        "util/languages/*.cc"
    )
    add_includedirs(".")
    add_headerfiles("compact_enc_det/*.h", {prefixdir = "compact_enc_det"})
    add_headerfiles("util/encodings/*.h", {prefixdir = "util/encodings"})
    add_headerfiles("util/languages/*.h", {prefixdir = "util/languages"})
]], {encoding = "binary"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <compact_enc_det/compact_enc_det.h>
            static void test() {
                volatile void* s = (void*)&CompactEncDet::DetectEncoding; if (s) {};
            }
        ]]}))
    end)
