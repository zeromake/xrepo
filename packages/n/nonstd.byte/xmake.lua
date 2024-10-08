package("nonstd.byte")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/byte-lite")
    set_description("expected lite - Expected objects in C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/byte-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.3.0", "1a19e237b12bb098297232b0a74ec08c18ac07ac5ac6e659c1d5d8a4ed0e4813")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
