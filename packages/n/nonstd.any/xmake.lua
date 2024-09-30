package("nonstd.any")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/any-lite")
    set_description("any lite - A C++17-like any, a type-safe container for single values of any type for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/any-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.4.0", "889549098291a1313d2fc8cd12dcdab13214d05cdce7ed5fe2dc724cdd7b3125")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
