local function getVersion(version)
    local versions ={
        ["2024.07.23-alpha"] = "archive/2795d907078cfacd08695f6e1ad3f9c6e34b13f5.tar.gz",
        ["2024.09.08-alpha"] = "archive/18f7e7a948546ff36c3bfafa854b6a9cae1c6096.tar.gz",
        ["2024.09.14-alpha"] = "archive/4ffef5eb11b2f7a283bb63832884d0ea66e98705.tar.gz",
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
    add_versions("2024.09.14-alpha", "917f5ff902e21a0471a41973459397bc7242793f74bcf516efb691248b6e6028")
    add_versions("2024.09.08-alpha", "f7de0f5befbd5b0471a1aaf79a3a3720c0db7834a058fd1a054339f0a1f14e09")
    add_versions("2024.07.23-alpha", "da7d4e53a071e6f0afe1c304484ddc6152bee88e1fc732234020ac3699126a4d")
    add_versions("4.12.0", "4cb80084d20d20561548a2941b6d1eb7c30e6f0b9405e0d5df84bae3c1d7bbaf")
    on_install(function (package)
        os.cp("./nuklear.h", package:installdir("include/nuklear"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
