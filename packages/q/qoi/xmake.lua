local function getVersion(version)
    local versions ={
        ["2025.02.12-alpha"] = "archive/d0cf1dfcc371f894da88a8d5fb3b08c2e8ad7474.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("qoi")
    set_homepage("https://qoiformat.org")
    set_description("The “Quite OK Image Format” for fast, lossless image compression")
    set_license("MIT")
    set_urls("https://github.com/phoboslab/qoi/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.02.12-alpha", "sha256")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        os.cp("qoi.h", package:installdir("include"))
        package:addenv("PATH", "bin")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
