package("nonstd.optional")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/optional-lite")
    set_description("optional lite - A C++17-like optional, a nullable object for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/optional-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("3.6.0", "2be17fcfc764809612282c3e728cabc42afe703b9dc333cc87c48d882fcfc2c2")
    add_versions("3.5.0", "6077cee87e2812afd05a273645051e0b55397a25c220295ddc1d6f49d0cf5cc8")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
