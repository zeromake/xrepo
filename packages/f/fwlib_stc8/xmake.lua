local function getVersion(version)
    local versions ={
        ["2024.09.03-alpha"] = "archive/1a68f176ddc1853d0c0165b74ae29d896604752a.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end


package("fwlib_stc8")
    set_homepage("https://github.com/IOsetting/FwLib_STC8.git")
    set_description("A lite firmware library for STC8G/STC8H series MCU")
    set_license("MIT")
    set_urls("https://github.com/IOsetting/FwLib_STC8/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.09.03-alpha", "646a64854352dc8024a51f6c93e72a5e59ad382eeadbbd200bb78baaf5d74bc0")
    add_configs("model", {description = "STC8 model", default = "STC8H1K08", values = {"STC8H1K08", "STC8H8K64U", "STC8G1K08"}})
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            model = package:config("model"),
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
