
package("plutosvg")
    set_homepage("https://github.com/sammycage/plutosvg")
    set_description("Tiny SVG rendering library in C")
    set_license("MIT")
    set_urls("https://github.com/sammycage/plutosvg/archive/refs/tags/v0.0.6.tar.gz")

    --insert version
    add_versions("0.0.6", "01f8aee511bd587a602a166642a96522cc9522efd1e38c2d00e4fbc0aa22d7a0")
    add_deps("plutovg")
    add_configs("freetype", {description = "Support freetype", default = false, type = "boolean"})
    on_load(function (package) 
        if package:config("shared") ~= true then
            package:add("defines", "PLUTOSVG_BUILD_STATIC")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            "--freetype=" .. (package:config("freetype") and "y" or "n"),
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
