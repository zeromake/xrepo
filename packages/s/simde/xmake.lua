package("simde")
    set_kind("library", {headeronly = true})
    set_license("MIT")
    set_homepage("simd-everywhere.github.io/blog/")
    set_description("Implementations of SIMD instruction sets for systems which don't natively support them.")

    set_urls("https://github.com/simd-everywhere/simde/releases/download/v$(version)/simde-amalgamated-$(version).tar.xz")

    add_versions("0.8.2", "59068edc3420e75c5ff85ecfd80a77196fb3a151227a666cc20abb313a5360bf")

    on_install(function (package)
        os.cp("*", package:installdir("include/simde"))
    end)

    on_test(function (package)
        assert(package:has_cincludes("simde/x86/sse.h"))
        assert(package:has_cincludes("simde/arm/neon.h"))
    end)
