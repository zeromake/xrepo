package("nonstd.scope")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/martinmoene/scope-lite")
    set_description("A migration path to C++ library extensions scope_exit, scope_fail, scope_success, unique_resource")
    set_license("BSL-1.0")
    set_urls("https://github.com/martinmoene/scope-lite/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("0.2.0", "a18f0ca9f02d884b29926a9d2f3bb81e6fdb201b4e13a5e7454232bdc6ab5e0f")
    on_install(function (package)
        os.cp("include/nonstd", package:installdir("include").."/")
    end)
