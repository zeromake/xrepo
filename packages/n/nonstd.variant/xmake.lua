package("nonstd.variant")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/variant-lite")
    set_description("variant lite - A C++17-like variant, a type-safe union for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/variant-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("3.0.0", "bd596550369f33ef9455566822f5a4d52852a63a33d3d70ac1fbb529b78abc7b")
    add_versions("2.0.0", "70c1509e24d03abfd22d2e702ab398238e69658b7b2890ce1d7e9731d6b5a7cb")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
