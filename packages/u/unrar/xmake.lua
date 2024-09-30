package("unrar")
    set_homepage("https://www.rarlab.com")
    set_description("UnRAR source code.")
    set_urls("https://www.rarlab.com/rar/unrarsrc-7.0.9.tar.gz")

    --insert version
    add_versions("7.0.9", "505c13f9e4c54c01546f2e29b2fcc2d7fabc856a060b81e5cdfe6012a9198326")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "*.lua"), "./")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
