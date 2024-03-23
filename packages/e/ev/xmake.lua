local function getVersion(version)
    local versions = {
        ["2024.03.22-alpha"] = "archive/9503d23eb7b2e1d2c8ec7d5e1c41dca4e8c07e58.tar.gz",
    }
    if versions[tostring(version)] == nil then
        return "archive/refs/tags/v"..tostring(version)..".tar.gz"
    end
    return versions[tostring(version)]
end

package("ev")
    set_homepage("http://software.schmorp.de/pkg/libev")
    set_description("libev is a high-performance event loop/event model with lots of features.")
    set_license("MIT")
    set_urls("https://github.com/zeromake/libev/$(version)", {
        version = getVersion
    })

    add_versions("2024.03.22-alpha", "2c5a3c639b02811d6a00badd496049bd9595da2ca17069c7ce8ca523736383b5")
    on_install(function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
