local function getVersion(version)
    local versions ={
        ["2024.07.01-alpha"] = "archive/4dd86943ce0fa8e550cfa10f40a9082d1a5ad133.tar.gz",
        ["2024.09.10-alpha"] = "archive/28b12feca7e77e41eccc8e9f7c293acc7fc1a7b1.tar.gz",
        ["2024.11.07-alpha"] = "archive/728c80914cbfbf23f3117ca603c99fd761dc2c22.tar.gz",
        ["2025.04.22-alpha"] = "archive/bb4cf5505a77c79f41fc220596ced07d5dce445d.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("rapidxml")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/dwd/rapidxml")
    set_description("RapidXML fork; XML namespacing, per-element parsing, etc ")
    set_license("MIT")
    set_urls("https://github.com/dwd/rapidxml/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2025.04.22-alpha", "c346584dfcdf1ac8ed2b41948d3e56789fe6df4a0519c391666668669df03d55")
    add_versions("2024.11.07-alpha", "825ee739bf297887d7197bee4eb12c5b790a1bafbae9a50209a932816d5015d8")
    add_versions("2024.09.10-alpha", "17c898d6f75b9d045cfa74f34c183055b8da969f8e1a4ca5704b1bb7b6f1dff5")
    add_versions("2024.07.01-alpha", "e90d4b22adacf5f995e0c785c0ee61fd5c3315553c7157822afb9d85bf28dd0b")
    on_install(function (package)
        os.cp("*.hpp", package:installdir("include"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
