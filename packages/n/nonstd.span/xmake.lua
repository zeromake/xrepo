package("nonstd.span")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/span-lite")
    set_description("span lite - A C++20-like span for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/span-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.11.0", "ef4e028e18ff21044da4b4641ca1bc8a2e2d656e2028322876c0e1b9b6904f9d")
    add_versions("0.10.3", "04ac8148760369f11d4cdbc7969d66cb3d372357b6b5c7744841a60551ccb50b")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
