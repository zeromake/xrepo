package("nonstd.ring-span")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/ring-span-lite")
    set_description("ring-span lite - A C++yy-like ring_span type for C++98, C++11 and later in a single-file header-only library")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/ring-span-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.7.0", "7650bb1bcf76cb0f7ac75240c5346203cbe7eb7027c0843c60253f6db08a93c1")
    add_versions("0.6.0", "3248ee40a3147e6ba3cee051a838f727770654ade0c9852b1640f0f40d2e0573")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
