package("msdf-atlas-gen")
    set_homepage("https://github.com/Chlumsky/msdf-atlas-gen")
    set_description("MSDF font atlas generator")
    set_license("MIT")
    set_urls("https://github.com/Chlumsky/msdf-atlas-gen/archive/refs/tags/v1.3.tar.gz")

    --insert version
    add_versions("1.3", "5d3d58e8bc92836baf23ce3a80ef79cc4c2d022fb86b7f160b11cc06cd62fe78")
    add_configs("cli", {description = "build cli", default = false, type = "boolean"})
    add_deps("msdfgen", "artery-font")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            cli = package:config("cli") and 'y' or 'n'
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
