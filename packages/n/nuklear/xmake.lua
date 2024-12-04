local function getVersion(version)
    local versions ={
        ["2024.10.19-alpha"] = "archive/6566d9075d5fed48af014c93f87c4aed8c4bd21c.tar.gz",
        ["2024.11.05-alpha"] = "archive/985ddcbccb7b716b9318183b1dc8bec11df447ce.tar.gz",
        ["2024.11.08-alpha"] = "archive/a315d25b4c33efa0e112cab9562460e785935a10.tar.gz",
        ["2024.11.26-alpha"] = "archive/31c580725bcdf3884a3035f33bd84a722c94c26b.tar.gz",
        ["2024.11.30-alpha"] = "archive/2d3a10bb98db906b78852f9af0290a96f98c0c4d.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end
package("nuklear")
    set_kind("library", {headeronly = true})
    set_homepage("https://immediate-mode-ui.github.io/Nuklear/doc/index.html")
    set_description("A single-header ANSI C immediate mode cross-platform GUI library")
    set_license("MIT")
    set_urls("https://github.com/Immediate-Mode-UI/Nuklear/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("2024.11.30-alpha", "4e845369a89ce33d067bc7939f85f8f2e1ed7550861d5db7f460c94b8d4e9f86")
    add_versions("2024.11.26-alpha", "f83e0a97809007ea032f64671678a08357d7cc928319ad96ac5cd4ce7ad891f4")
    add_versions("4.12.2", "a705e626a7190722fc5bd3b298e0be35b3d3d92eccf017660ef251cab29fcc94")
    add_versions("2024.11.08-alpha", "fbb1fba921ca73746690d82e67ae9a8fa7d42759459ddb8182ff0f8857ccb59e")
    add_versions("2024.11.05-alpha", "2075f9385d9fd3c92f70c5388a7815532d8a35bd41a7e91f3f26f7487b178d06")
    add_versions("2024.10.19-alpha", "ca9d537cd0232a4c8ab58e1220e68972f906b314ac5de7b79e354f10859d9acf")
    add_versions("4.12.0", "4cb80084d20d20561548a2941b6d1eb7c30e6f0b9405e0d5df84bae3c1d7bbaf")
    on_install(function (package)
        os.cp("./nuklear.h", package:installdir("include/nuklear"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
