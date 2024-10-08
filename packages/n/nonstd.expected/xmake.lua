package("nonstd.expected")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/expected-lite")
    set_description("expected lite - Expected objects in C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/expected-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.8.0", "27649f30bd9d4fe7b193ab3eb6f78c64d0f585c24c085f340b4722b3d0b5e701")
    add_versions("0.7.0", "8e266cd304d405e02a6b4abf881ab7d8e203ca719c513711cf89a3b4e5d97918")
    add_versions("0.6.3", "b2f90d5f03f6423ec67cc3c06fd0c4e813ec10c4313062b875b37d17593b57b4")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
