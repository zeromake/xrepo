local options = {
    "yuv",
    "webp"
}

package("avif")
    set_homepage("https://aomediacodec.github.io/av1-avif/")
    set_description("libavif - Library for encoding and decoding .avif files")
    set_license("MIT")
    set_urls("https://github.com/AOMediaCodec/libavif/archive/refs/tags/v$(version).tar.gz")

    --insert version
    add_versions("1.2.0", "2182f4900d1a9617cee89746922a58dd825f2a3547f23907b8d78dc3685f7d8c")
    add_versions("1.1.1", "914662e16245e062ed73f90112fbb4548241300843a7772d8d441bb6859de45b")
    add_versions("1.1.0", "edb31951005d7a143be1724f24825809599a4832073add50eaf987733defb5c8")
    add_versions("1.0.4", "dc56708c83a4b934a8af2b78f67f866ba2fb568605c7cf94312acf51ee57d146")
    add_versions("1.0.1", "398fe7039ce35db80fe7da8d116035924f2c02ea4a4aa9f4903df6699287599c")
    
    for _, op in ipairs(options) do
        add_configs(op, {description = "Support "..op, default = false, type = "boolean"})
    end
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
            local v = package:config(op) ~= false and "y" or "n"
            configs[op] = v
        end
        import("package.tools.xmake").install(package, configs)
    end)


    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
