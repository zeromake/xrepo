local options = {
    "zlib",
    "bzip2",
    "brotli",
    "png",
    "harfbuzz",
}

package("freetype")
    set_homepage("https://freetype.org")
    set_description("FreeType is a freely available software library to render fonts.")

    set_license("FTL")
    set_urls("https://download.sourceforge.net/freetype/freetype2/$(version)/freetype-$(version).tar.gz")
    add_versions("2.13.2", "1ac27e16c134a7f2ccea177faba19801131116fd682efc1f5737037c5db224b5")
    add_versions("2.12.1", "efe71fd4b8246f1b0b1b9bfca13cfff1c9ad85930340c27df469733bbb620938")
    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end

    add_includedirs("include")

    on_load(function (package)
        for _, op in ipairs(options) do
            if package:config(op) then
                package:add("deps", op)
            end
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        for _, op in ipairs(options) do
            local v = "n"
            if package:config(op) ~= false then
                v = "y"
            end
            table.insert(configs, "--"..op.."="..v)
        end
        import("package.tools.xmake").install(package, configs)
        os.cp(path.join("include", "freetype"), package:installdir("include"))
        if os.exists(path.join("include", "dlg")) then
            os.cp(path.join("include", "dlg"), package:installdir("include"))
        end
        os.cp(path.join("include", "ft2build.h"), package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("FT_Init_FreeType", {includes = {"ft2build.h", "freetype/freetype.h"}}))
    -- end)
