package("nonstd.string_view")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/string-view-lite")
    set_description("string_view lite - A C++17-like string_view for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/string-view-lite/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.8.0", "9b38c32621eb1a81a7fa59427144309225c414a7bae522ab3a2d9ae239dd35be")
    add_versions("1.7.0", "265eaec08c4555259b46f5b03004dbc0f7206384edfac1cd5a837efaa642e01c")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)

